import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/model/list_report_model.dart';
import 'package:aggar/features/main_screen/admin/model/report_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  bool isLoadingMore = false;
  int currentPage = 1;
  List<ReportModel> allReports = [];
  int totalPages = 0;

  String? _lastTargetType;
  String? _lastStatus;
  String? _lastDate;
  String? _lastSortingDirection;

  final List<String> reportTypes = [
    'Message',
    'CustomerReview',
    'RenterReview',
    'AppUser',
    'Vehicle',
    'Booking',
    'Rental'
  ];

  bool _filtersChanged(String? targetType, String? status, String? date,
      String? sortingDirection) {
    return _lastTargetType != targetType ||
        _lastStatus != status ||
        _lastDate != date ||
        _lastSortingDirection != sortingDirection;
  }

  void _updateLastFilters(String? targetType, String? status, String? date,
      String? sortingDirection) {
    _lastTargetType = targetType;
    _lastStatus = status;
    _lastDate = date;
    _lastSortingDirection = sortingDirection;
  }

  Future<void> fetchReports(String accessToken, String? targetType,
      String? status, String? date, String? sortingDirection,
      {bool isLoadMore = false}) async {
    if (_filtersChanged(targetType, status, date, sortingDirection) ||
        !isLoadMore) {
      currentPage = 1;
      allReports.clear();
      isLoadMore = false;
      _updateLastFilters(targetType, status, date, sortingDirection);
    }
    if (isLoadMore && currentPage > totalPages && totalPages > 0) {
      isLoadingMore = false;
      return;
    }

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        if (!isLoadMore) {
          emit(ReportLoading());
        } else {
          emit(ReportsLoadingMore(
              reports:
                  ListReportModel(data: allReports, totalPages: totalPages)));
        }

        final response = await dioConsumer.get(
          EndPoint.filterReport,
          data: {
            "pageNo": currentPage,
            "pageSize": 8,
            "targetType": targetType,
            "status": status,
            "date": date,
            "sortingDirection": sortingDirection
          },
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
        );

        final reports = ListReportModel.fromJson(response);
        totalPages = reports.totalPages!;

        if (isLoadMore) {
          allReports.addAll(reports.data);
        } else {
          allReports = List.from(reports.data);
        }
        if (isLoadMore && reports.data.isNotEmpty) {
          currentPage++;
        } else if (!isLoadMore) {
          currentPage = 2;
        }
        if (allReports.length > 100) {
          allReports.removeRange(0, allReports.length - 100);
        }

        emit(ReportsLoaded(
          reports: ListReportModel(
            data: allReports,
            totalPages: totalPages,
          ),
        ));
        return;
      } catch (error) {
        if (attempt == 3) {
          emit(ReportError(
              message:
                  'Failed to fetch reports after $attempt attempts: $error'));
        }
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      } finally {
        isLoadingMore = false;
      }
    }
  }

  Future<void> refreshReports(String accessToken, String? targetType,
      String? status, String? date, String? sortingDirection) async {
    currentPage = 1;
    allReports.clear();
    await fetchReports(accessToken, targetType, status, date, sortingDirection);
  }

  Future<void> updateReportStatus(
      String accessToken, String status, List<int> reportIds) async {
    try {
      emit(ReportLoading());
      // ignore: unused_local_variable
      final response = await dioConsumer.put(
        EndPoint.updateReportStatus,
        data: {
          "reportsIds": reportIds,
          "status": status,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json"
          },
        ),
      );
      emit(ReportUpdateStatus());
    } catch (error) {
      String errorMessage = handleError(error);
      emit(ReportError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }

  Future<void> fetchReportById(String accessToken, int id) async {
    try {
      emit(ReportLoading());
      final response = await dioConsumer.get(
        EndPoint.getReportById,
        queryParameters: {
          "reportId": id,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final report = ReportModel.fromJson(response);
      emit(ReportByIdLoaded(report: report));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(ReportError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }

  void clearReports() {
    currentPage = 1;
    totalPages = 0;
    allReports.clear();
    isLoadingMore = false;
    _lastTargetType = null;
    _lastStatus = null;
    _lastDate = null;
    _lastSortingDirection = null;
    emit(ReportInitial());
  }
}
