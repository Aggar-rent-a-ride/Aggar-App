import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_brand_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_vehicle_brand_state.dart';

class EditVehicleBrandCubit extends Cubit<EditVehicleBrandState> {
  EditVehicleBrandCubit() : super(EditVehicleBrandInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  TextEditingController vehicleBrandNameController = TextEditingController();
  TextEditingController vehicleBrandCountryController = TextEditingController();
  File? image;
  String? imageUrl;
  final formKey = GlobalKey<FormState>();

  void setImageFile(File? file) {
    image = file;
    emit(EditVehicleBrandImageUpdated(image: image, imageUrl: imageUrl));
  }

  void setImageUrl(String? url) {
    imageUrl = url;
    emit(EditVehicleBrandImageUpdated(image: image, imageUrl: imageUrl));
  }

  Future<void> updateVehicleBrand(String accessToken, int id, String name,
      File? image, String? imageUrl, String country) async {
    try {
      emit(EditVehicleBrandLoading());
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
      emit(EditVehicleBrandUpdated(vehicleBrandModel: vehicleBrandList));
    } catch (error) {
      emit(EditVehicleBrandError(message: error.toString()));
    }
  }

  void resetFields() {
    vehicleBrandNameController.clear();
    vehicleBrandCountryController.clear();
    imageUrl = '';
    setImageFile(null);
  }
}
