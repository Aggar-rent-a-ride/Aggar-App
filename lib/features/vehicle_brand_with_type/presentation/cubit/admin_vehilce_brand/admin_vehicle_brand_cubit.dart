import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_brand_model.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_brand_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_vehicle_brand_state.dart';

class AdminVehicleBrandCubit extends Cubit<AdminVehicleBrandState> {
  AdminVehicleBrandCubit() : super(AdminVehicleBrandInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  TextEditingController vehicleBrandNameController = TextEditingController();
  TextEditingController vehicleBrandCountryController = TextEditingController();
  File? image;
  String? imageUrl;
  final YformKey = GlobalKey<FormState>();

  void setImageFile(File? file) {
    image = file;
    emit(AdminVehicleBrandImageUpdated(image: image, imageUrl: imageUrl));
  }

  void setImageUrl(String? url) {
    imageUrl = url;
    emit(AdminVehicleBrandImageUpdated(image: image, imageUrl: imageUrl));
  }

  Future<void> fetchVehicleBrands(String accessToken) async {
    try {
      emit(AdminVehicleBrandLoading());
      final response = await dioConsumer.get(
        EndPoint.vehicleBrand,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehicleBrandList = ListVehicleBrandModel.fromJson(response);
      emit(AdminVehicleBrandLoaded(listVehicleBrandModel: vehicleBrandList));
    } catch (error) {
      emit(AdminVehicleBrandError(message: error.toString()));
    }
  }

  Future<void> createVehicleBrand(
      String accessToken, String name, File? image, String country) async {
    try {
      emit(AdminVehicleBrandLoading());
      FormData formData = FormData.fromMap({
        ApiKey.vehicleBrandName: name,
        ApiKey.vehicleBrandCountry: country,
        if (image != null)
          "logo": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });
      final response = await dioConsumer.post(
        EndPoint.vehicleBrand,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response["statusCode"] == 201) {
        emit(AdminVehicleBrandAdded());
      }
    } catch (error) {
      emit(AdminVehicleBrandError(message: error.toString()));
    }
  }

  Future<void> updateVehicleBrand(String accessToken, int id, String name,
      File? image, String? imageUrl, String country) async {
    try {
      emit(AdminVehicleBrandLoading());
      FormData formData = FormData.fromMap({
        ApiKey.vehicleBrandName: name,
        ApiKey.vehicleBrandCountry: country,
        ApiKey.vehicleBrandId: id,
        if (image != null && image.path.isNotEmpty)
          "logo": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        if (image == null && imageUrl != null) "logo": imageUrl,
      });
      final response = await dioConsumer.put(
        EndPoint.vehicleBrand,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      final vehicleBrandList = VehicleBrandModel.fromJson(response["data"]);
      emit(AdminVehicleBrandUpdated(vehicleBrandModel: vehicleBrandList));
    } catch (error) {
      emit(AdminVehicleBrandError(message: error.toString()));
    }
  }

  Future<void> deleteVehicleBrand(String accessToken, int id) async {
    try {
      emit(AdminVehicleBrandLoading());
      final response = await dioConsumer.delete(
        EndPoint.vehicleBrand,
        queryParameters: {"id": id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response["statusCode"] == 200) {
        emit(AdminVehicleBrandDeleted());
      } else {
        emit(const AdminVehicleBrandError(message: "error"));
      }
    } catch (error) {
      emit(AdminVehicleBrandError(message: error.toString()));
    }
  }

  void resetFields() {
    vehicleBrandNameController.clear();
    vehicleBrandCountryController.clear();
    image = null;
    emit(const AdminVehicleBrandImageUpdated(image: null, imageUrl: null));
  }
}
