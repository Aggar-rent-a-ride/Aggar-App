import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_type_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_vehicle_type_state.dart';

class EditVehicleTypeCubit extends Cubit<EditVehicleTypeState> {
  EditVehicleTypeCubit() : super(EditVehicleTypeInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  TextEditingController vehicleTypeNameController = TextEditingController();
  File? image;
  String? imageUrl;
  final formKey = GlobalKey<FormState>();

  void setImageFile(File? file) {
    image = file;
    emit(EditVehicleTypeImageUpdated(image: image, imageUrl: imageUrl));
  }

  void setImageUrl(String? url) {
    imageUrl = url;
    emit(EditVehicleTypeImageUpdated(image: image, imageUrl: imageUrl));
  }

  Future<void> updateVehicleType(String accessToken, int id, String name,
      File? image, String? imageUrl) async {
    try {
      emit(EditVehicleTypeLoading());
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
      emit(EditVehicleTypeUpdated(vehicleTypeModel: vehicleTypeList));
    } catch (error) {
      emit(EditVehicleTypeError(message: error.toString()));
    }
  }

  void resetFields() {
    vehicleTypeNameController.clear();
    imageUrl = '';
    setImageFile(null);
  }
}
