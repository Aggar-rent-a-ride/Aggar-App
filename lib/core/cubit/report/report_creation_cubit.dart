import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/report/report_creation_state.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCreationCubit extends Cubit<ReportCreationState> {
  ReportCreationCubit() : super(ReportCreationInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  Future<void> createReport(
      String accessToken, int id, String targetType, String description) async {
    try {
      emit(ReportLoading());
      final response = await dioConsumer.post(
        EndPoint.createReport,
        data: {
          "targetId": id,
          "description": description,
          "targetType": targetType,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      emit(ReportsSuccess(message: response["message"]));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(ReportError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }
}
