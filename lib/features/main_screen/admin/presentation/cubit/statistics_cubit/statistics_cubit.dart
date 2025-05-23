import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/model/list_report_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final List<String> reportTypes = [
    'Message',
    'CustomerReview',
    'RenterReview',
    'AppUser',
    'Vehicle',
    'Booking',
    'Rental'
  ];
  Future<void> fetchTotalReports(String accessToken) async {
    try {
      emit(StatisticsLoading());
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
      emit(StatisticsLoaded(
        totalReportsByType: totalReportsByType,
      ));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(StatisticsError(
          message: 'An unexpected error occurred: $errorMessage'));
    }
  }
}
