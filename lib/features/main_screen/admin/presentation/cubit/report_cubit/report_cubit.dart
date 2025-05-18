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

  Future<void> filterReports(String accessToken) async {
    try {
      emit(ReportLoading());
      final response = await dioConsumer.get(
        EndPoint.filterReport,
        data: {
          "pageNo": 1,
          "pageSize": 10,
          "targetType": "Message",
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
      print(reports.data[0]);
      print("kkkkk");
      emit(ReportLoaded(reports: reports));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(ReportError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }
}
