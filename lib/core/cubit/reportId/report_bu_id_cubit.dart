import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/model/report_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBuIdCubit extends Cubit<ReportByIdState> {
  ReportBuIdCubit() : super(ReportByIdInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  Future<void> fetchReportById(String accessToken, int id) async {
    try {
      emit(ReportsByIdLoading());
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
      emit(ReportByIdError(message: errorMessage));
    }
  }
}
