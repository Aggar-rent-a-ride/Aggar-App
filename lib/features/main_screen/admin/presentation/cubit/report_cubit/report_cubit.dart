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
  final List<String> reportTypes = [
    'Message',
    'CustomerReview',
    'RenterReview',
    'AppUser',
    'Vehicle',
    'Booking',
    'Rental'
  ];

  Future<void> fetchReports(String accessToken, String? targetType,
      String? status, String? date, String? sortingDirection,
      {bool isLoadMore = false}) async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        if (!isLoadMore) {
          emit(ReportLoading());
        } else {
          emit(ReportsLoadingMore(
              reports: ListReportModel(data: allReports, totalPages: 0)));
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

        if (isLoadMore) {
          allReports.addAll(reports.data);
          currentPage++;
        } else {
          allReports = reports.data;
          currentPage = 1;
        }
        if (allReports.length > 50) {
          allReports.removeRange(0, allReports.length - 50);
        }
        emit(ReportsLoaded(
          reports: ListReportModel(
            data: allReports,
            totalPages: reports.totalPages,
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
}
