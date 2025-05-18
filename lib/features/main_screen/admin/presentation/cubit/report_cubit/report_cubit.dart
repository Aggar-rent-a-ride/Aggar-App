import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/model/list_report_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  // List of report types
  final List<String> reportTypes = [
    'Message',
    'CustomerReview',
    'RenterReview',
    'AppUser',
    'Vehicle',
    'Booking',
    'Rental'
  ];

  Future<void> filterReportsTargetType(
      String accessToken, String targetType) async {
    try {
      emit(ReportLoading());
      final response = await dioConsumer.get(
        EndPoint.filterReport,
        data: {
          "pageNo": 1,
          "pageSize": 1,
          "targetType": targetType,
          "status": null,
          "date": null,
          "sortingDirection": null
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final reports = ListReportModel.fromJson(response);
      emit(ReportLoaded(reports: reports));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(ReportError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }

  Future<void> fetchReportTotals(String accessToken) async {
    try {
      emit(ReportLoading());
      final Map<String, int> totalReportsByType = {};
      for (String type in reportTypes) {
        final response = await dioConsumer.get(
          EndPoint.filterReport,
          data: {
            "pageNo": 1,
            "pageSize": 1,
            "targetType": type,
            "status": null,
            "date": null,
            "sortingDirection": null
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );
        final reports = ListReportModel.fromJson(response);
        totalReportsByType[type] = reports.totalPages ?? 0;
      }
      emit(ReportTotalsLoaded(totalReportsByType: totalReportsByType));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(ReportError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }
}
