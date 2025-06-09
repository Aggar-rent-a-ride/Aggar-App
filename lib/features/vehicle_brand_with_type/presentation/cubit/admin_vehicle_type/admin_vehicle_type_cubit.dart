import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_type_model.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_type_model.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminVehicleTypeCubit extends Cubit<AdminVehicleTypeState> {
  AdminVehicleTypeCubit() : super(AdminVehicleTypeInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  TextEditingController vehicleTypeNameController = TextEditingController();
  File? image;
  String? imageUrl;
  final XformKey = GlobalKey<FormState>();

  void setImageFile(File? file) {
    image = file;
    emit(AdminVehicleTypeImageUpdated(image: image, imageUrl: imageUrl));
  }

  void setImageUrl(String? url) {
    imageUrl = url;
    emit(AdminVehicleTypeImageUpdated(image: image, imageUrl: imageUrl));
  }

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
      final vehicleTypeList = ListVehicleTypeModel.fromJson(response);
      emit(AdminVehicleTypeLoaded(vehicleTypeList));
    } catch (error) {
      emit(AdminVehicleTypeError(message: error.toString()));
    }
  }

  Future<void> createVehicleType(
      String accessToken, String name, File? image) async {
    try {
      emit(AdminVehicleTypeLoading());
      FormData formData = FormData.fromMap({
        ApiKey.vehicleTypeName: name,
        if (image != null)
          "slogan": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });
      final response = await dioConsumer.post(
        EndPoint.vehicleType,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response["statusCode"] == 201) {
        emit(AdminVehicleTypeAdded());
        await fetchVehicleTypes(accessToken);
      }
    } catch (error) {
      emit(AdminVehicleTypeError(message: error.toString()));
    }
  }

  Future<void> updateVehicleType(String accessToken, int id, String name,
      File? image, String? imageUrl) async {
    try {
      emit(AdminVehicleTypeLoading());
      FormData formData = FormData.fromMap({
        ApiKey.vehicleTypeName: name,
        'id': id,
        if (image != null && image.path.isNotEmpty)
          "slogan": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        if (image == null && imageUrl != null) 'slogan': imageUrl,
      });

      final response = await dioConsumer.put(
        EndPoint.vehicleType,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      final vehicleTypeList = VehicleTypeModel.fromJson(response["data"]);
      emit(AdminVehicleTypeUpdated(vehicletypeModel: vehicleTypeList));
      await fetchVehicleTypes(accessToken);
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
        await fetchVehicleTypes(accessToken);
      } else {
        emit(const AdminVehicleTypeError(message: "error"));
      }
    } catch (error) {
      emit(const AdminVehicleTypeError(
          message: "Vehicle type with that id wasn't found"));
    }
  }

  void resetFields() {
    vehicleTypeNameController.clear();
    image = null;
    imageUrl = null;
    if (state is AdminVehicleTypeLoaded) {
      emit(AdminVehicleTypeLoaded(
          (state as AdminVehicleTypeLoaded).listVehicleTypeModel));
    } else {
      emit(const AdminVehicleTypeImageUpdated(image: null, imageUrl: null));
    }
  }
}
