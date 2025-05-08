import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  Future<void> fetchVehicle(String accessToken) async {
    try {
      emit(VehicleLoading());
      final response = await dioConsumer.get(
        EndPoint.getVehicles,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      final vehicles = ListVehicleModel.fromJson(response);
      emit(VehicleLoaded(vehicles: vehicles));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          emit(VehicleError(
              message: 'Access forbidden: Invalid or expired token.'));
        } else if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          emit(VehicleError(message: 'Network timeout. Please try again.'));
        } else if (error.type == DioExceptionType.connectionError) {
          emit(VehicleError(
              message: 'No internet connection. Please check your network.'));
        } else {
          emit(VehicleError(
              message:
                  'Server error: ${error.response?.statusCode ?? 'Unknown'}'));
        }
      } else {
        debugPrint('Unexpected Error: $error');
        emit(VehicleError(message: 'An unexpected error occurred: $error'));
      }
    }
  }
}
