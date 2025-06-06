import 'dart:io';

import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_type_model.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminVehicleTypeCubit extends Cubit<AdminVehicleTypeState> {
  AdminVehicleTypeCubit() : super(AdminVehicleTypeInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  Future<void> fetchVehicleTypes(String accessToken) async {
    try {
      emit(AdminVehicleTypeLoading());
      final response = await dioConsumer.get(
        EndPoint.vehicleType,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehilceTypeList = ListVehicleTypeModel.fromJson(response);
      emit(AdminVehicleTypeLoaded(listVehicleTypeModel: vehilceTypeList));
    } catch (error) {
      emit(AdminVehicleTypeError(message: error.toString()));
    }
  }

  Future<void> createVehicleType(
      String accessToken, String name, File image) async {
    try {
      emit(AdminVehicleTypeLoading());
      final response = await dioConsumer.post(
        EndPoint.vehicleType,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehilceTypeList = ListVehicleTypeModel.fromJson(response);
      emit(AdminVehicleTypeLoaded(listVehicleTypeModel: vehilceTypeList));
    } catch (error) {
      emit(AdminVehicleTypeError(message: error.toString()));
    }
  }

  Future<void> updateVehicleType(
      String accessToken, int id, String name, File image) async {
    try {
      emit(AdminVehicleTypeLoading());
      final response = await dioConsumer.put(
        EndPoint.vehicleType,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehilceTypeList = ListVehicleTypeModel.fromJson(response);
      emit(AdminVehicleTypeLoaded(listVehicleTypeModel: vehilceTypeList));
    } catch (error) {
      emit(AdminVehicleTypeError(message: error.toString()));
    }
  }

  Future<void> deleteVehicleType(String accessToken, int id) async {
    try {
      emit(AdminVehicleTypeLoading());
      final response = await dioConsumer.delete(
        EndPoint.vehicleType,
        queryParameters: {"id": id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response["statusCode"] == 200) {
        emit(AdminVehicleTypeDeleted());
      } else {
        emit(AdminVehicleTypeError(message: "error"));
      }
    } catch (error) {
      emit(AdminVehicleTypeError(message: error.toString()));
    }
  }
}
