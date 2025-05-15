import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  Future<void> fetchVehicle(String accessToken) async {
    try {
      emit(VehicleLoading());
      final response = await dioConsumer.get(
        EndPoint.getPopularVehicles,
        queryParameters: {"pageNo": 1, "pageSize": 10},
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      final vehicles = ListVehicleModel.fromJson(response);
      emit(VehicleLoaded(vehicles: vehicles));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(
          VehicleError(message: 'An unexpected error occurred: $errorMessage'));
    }
  }
}
