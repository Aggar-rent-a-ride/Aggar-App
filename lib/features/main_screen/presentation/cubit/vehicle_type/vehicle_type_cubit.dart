import 'dart:convert';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/end_points.dart';
import 'vehicle_type_state.dart';

class VehicleTypeCubit extends Cubit<VehicleTypeState> {
  VehicleTypeCubit() : super(VehicleTypeInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final List<String> vehicleTypes = [];
  final List<int> vehicleTypeIds = [];
  final List<String> vehicleTypeSlogenPaths = [];
  Future<void> fetchVehicleTypes(String accessToken) async {
    try {
      emit(VehicleTypeLoading());
      final response = await dioConsumer.get(
        EndPoint.vehicleType,
        options: Options(
          headers: {
            'Authorization': "Bearer $accessToken",
          },
        ),
      );
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        vehicleTypes.clear();
        vehicleTypeIds.clear();
        vehicleTypeSlogenPaths.clear();
        for (var item in decodedJson['data']) {
          vehicleTypes.add(item[ApiKey.vehicleTypeName]);
          vehicleTypeIds.add(item[ApiKey.vehicleTypeId]);
          if (item[ApiKey.vehicleTypeSlogen] != null) {
            vehicleTypeSlogenPaths.add(item[ApiKey.vehicleTypeSlogen]);
          } else {
            vehicleTypeSlogenPaths.add("null");
          }
        }
        emit(VehicleLoadedType());
      } else {
        emit(VehicleTypeError(message: decodedJson['message']));
      }
      emit(VehicleLoadedType());
    } catch (error) {
      emit(VehicleTypeError(message: error.toString()));
    }
  }

  Future<void> fetchVehicleType(String accessToken, String type) async {
    try {
      emit(VehicleTypeLoading());
      final response = await dioConsumer.get(
        EndPoint.getVehicles,
        queryParameters: {
          "typeId": type,
          "pageNo": 1,
          "pageSize": 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehiclesType = ListVehicleModel.fromJson(response);
      emit(VehicleLoadedType(vehicles: vehiclesType));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          emit(VehicleTypeError(
              message: 'Access forbidden: Invalid or expired token.'));
        } else if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          emit(VehicleTypeError(message: 'Network timeout. Please try again.'));
        } else if (error.type == DioExceptionType.connectionError) {
          emit(VehicleTypeError(
              message: 'No internet connection. Please check your network.'));
        } else {
          emit(VehicleTypeError(
              message:
                  'Server error: ${error.response?.statusCode ?? 'Unknown'}'));
        }
      } else {
        debugPrint('Unexpected Error: $error');
        emit(VehicleTypeError(message: 'An unexpected error occurred: $error'));
      }
    }
  }
}
