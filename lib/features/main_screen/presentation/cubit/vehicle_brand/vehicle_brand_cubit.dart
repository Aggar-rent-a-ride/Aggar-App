import 'dart:convert';

import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../core/api/end_points.dart';

class VehicleBrandCubit extends Cubit<VehicleBrandState> {
  VehicleBrandCubit() : super(VehicleBrandInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final List<String> vehicleBrands = [];
  final List<int> vehicleBrandIds = [];
  final List<String> vehicleBrandLogoPaths = [];
  Future<void> fetchVehicleBrands(String accessToken) async {
    try {
      emit(VehicleBrandLoading());
      final response = await dio.get(
        Uri.parse(EndPoint.vehicleBrand),
        headers: {
          'Authorization': "Bearer $accessToken",
        },
      );
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        vehicleBrands.clear();
        vehicleBrandIds.clear();
        vehicleBrandLogoPaths.clear();
        for (var item in decodedJson['data']) {
          vehicleBrands.add(item[ApiKey.vehicleBrandName]);
          vehicleBrandIds.add(item[ApiKey.vehicleBrandId]);
          if (item[ApiKey.vehicleBrandLogo] != null) {
            vehicleBrandLogoPaths.add(item[ApiKey.vehicleBrandLogo]);
          } else {
            vehicleBrandLogoPaths.add("null");
          }
        }
        emit(VehicleLoadedBrand());
      }
    } catch (error) {
      emit(VehicleBrandError(message: error.toString()));
    }
  }

  Future<void> fetchVehicleBrand(String accessToken, String brand) async {
    try {
      emit(VehicleBrandLoading());
      final response = await dioConsumer.get(
        EndPoint.getVehicles,
        queryParameters: {"brandId": brand, "pageNo": 1, "pageSize": 10},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehiclesBrand = ListVehicleModel.fromJson(response);

      emit(VehicleLoadedBrand(vehicles: vehiclesBrand));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          emit(VehicleBrandError(
              message: 'Access forbidden: Invalid or expired token.'));
        } else if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          emit(
              VehicleBrandError(message: 'Network timeout. Please try again.'));
        } else if (error.type == DioExceptionType.connectionError) {
          emit(VehicleBrandError(
              message: 'No internet connection. Please check your network.'));
        } else {
          emit(VehicleBrandError(
              message:
                  'Server error: ${error.response?.statusCode ?? 'Unknown'}'));
        }
      } else {
        emit(
            VehicleBrandError(message: 'An unexpected error occurred: $error'));
      }
    }
  }
}
