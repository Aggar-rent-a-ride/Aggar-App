import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/edit_user_info/edit_user_info_state.dart';
import 'package:aggar/core/helper/estimate_date_of_birth.dart';
import 'package:aggar/features/profile/data/model/user_info_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

class EditUserInfoCubit extends Cubit<EditUserInfoState> {
  EditUserInfoCubit() : super(EditUserInfoInitial());
  final DioConsumer dio = DioConsumer(dio: Dio());
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  LatLng? selectedLocation;
  File? selectedImage;

  void updateImage(File image) {
    selectedImage = image;
    emit(EditUserInfoImageUpdated(image: image));
  }

  void disposeControllers() {
    nameController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
  }

  void updateLocation(LatLng location, String address) {
    selectedLocation = location;
    addressController.text = address;
    emit(EditUserInfoLocationUpdated(location: location, address: address));
  }

  Future<void> fetchUserInfo(String userId, String token) async {
    emit(EditUserInfoLoading());
    try {
      final response = await dio.get(
        EndPoint.getUserInfo,
        queryParameters: {"userId": userId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final userInfo = UserInfoModel.fromJson(response["data"]);
      nameController.text = userInfo.name;
      bioController.text = userInfo.bio ?? '';
      dateOfBirthController.text = estimateDateOfBirth(userInfo.age);
      addressController.text = userInfo.address;
      selectedLocation = LatLng(
        double.parse((userInfo.location.latitude).toString()),
        double.parse((userInfo.location.longitude).toString()),
      );
      emit(EditUserInfoSuccess(userInfoModel: userInfo));
    } catch (e) {
      emit(EditUserInfoError(errorMessage: e.toString()));
    }
  }

  Future<void> editProfile({
    required String token,
  }) async {
    emit(EditUserInfoLoading());
    try {
      final formData = FormData.fromMap({
        'name': nameController.text,
        if (selectedImage != null)
          'image': await MultipartFile.fromFile(selectedImage!.path),
        'Location.longitude': selectedLocation?.longitude.toString() ?? '',
        'Location.latitude': selectedLocation?.latitude.toString() ?? '',
        'address': addressController.text,
        'DateOfBirth': dateOfBirthController.text,
        'bio': bioController.text,
      });

      final response = await dio.put(
        EndPoint.editProfile,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final updatedUserInfo = UserInfoModel.fromJson(response["data"]);
      emit(EditUserInfoSuccess(userInfoModel: updatedUserInfo));
    } catch (e) {
      emit(EditUserInfoError(errorMessage: e.toString()));
    }
  }
}
