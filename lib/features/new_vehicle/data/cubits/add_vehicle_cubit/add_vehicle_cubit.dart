import 'dart:io';

import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart'
    show MainImageCubit;
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' show basename;
import '../../../../../core/api/end_points.dart';
import 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final MainImageCubit mainImageCubit;
  final AdditionalImageCubit additionalImageCubit;
  final MapLocationCubit mapLocationCubit;
  final ApiConsumer apiConsumer;
  late Dio _dio;

  AddVehicleCubit(this.apiConsumer, this.mainImageCubit,
      this.additionalImageCubit, this.mapLocationCubit)
      : super(AddVehicleInitial()) {
    selectedTransmissionModeValue = 0;
    emit(TransmissionModeUpdated(selectedTransmissionModeValue));
    emit(VehicleStatusUpdated(selectedVehicleStatusValue));
    // Initialize Dio with base URL and default options
    _dio = Dio(BaseOptions(
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiOGJjMzA4NDItNTgyZS00ZjhhLThlNTUtNzNkYjExZjgxOTM0IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzUzNzU3NSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.anUiZ3X1S6d7e8nxzG1uiG7G3WGr5xkg6ctYPfcqeH0',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
    ));
  }

  GlobalKey<FormState> addVehicleFormKey = GlobalKey();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleRentalPrice = TextEditingController();
  TextEditingController vehicleYearOfManufactureController =
      TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController vehicleSeatsNoController = TextEditingController();
  TextEditingController vehicleProperitesOverviewController =
      TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleStatusController = TextEditingController();
  TextEditingController vehicleAddressController = TextEditingController();
  int? selectedTransmissionModeValue;
  String? selectedVehicleBrandValue;
  String? selectedVehicleStatusValue;

  void setTransmissionMode(int value) {
    selectedTransmissionModeValue = value;
    emit(TransmissionModeUpdated(selectedTransmissionModeValue));
  }

  void setVehicleBrand(String value) {
    selectedVehicleBrandValue = value;
    vehicleBrandController.text = value;
    emit(VehicleBrandUpdated(selectedVehicleBrandValue));
  }

  void setVehicleStatus(String value) {
    selectedVehicleStatusValue = value;
    vehicleStatusController.text = value;
    emit(VehicleStatusUpdated(selectedVehicleStatusValue));
  }

  String? selectedVehicleTypeValue;
  void setVehicleType(String value) {
    selectedVehicleTypeValue = value;
    vehicleTypeController.text = value;
    emit(VehicleTypeUpdated(selectedVehicleTypeValue));
  }

  String? selectedVehicleHealthValue;

  void setVehicleHealth(String value) {
    if (selectedVehicleHealthValue == value) {
      selectedVehicleHealthValue = null;
    } else {
      selectedVehicleHealthValue = value;
    }
    emit(VehicleHealthUpdated(selectedVehicleHealthValue));
  }

  String getVehicleTransmission() {
    String transmissionMode;
    switch (selectedTransmissionModeValue) {
      case 2:
        transmissionMode = "Manual";
        break;
      case 1:
        transmissionMode = "Automatic";
        break;
      case 0:
        transmissionMode = "None";
        break;
      default:
        transmissionMode = "None";
    }
    return transmissionMode;
  }

  String getVehicleHealth() {
    String health;
    switch (selectedVehicleHealthValue) {
      case "Excellent":
        health = "Excellent";
        break;
      case "Minor dents":
        health = "Scratched";
        break;
      case "Good":
        health = "Good";
        break;
      case "Not bad":
        health = "NotBad";
        break;
      default:
        health = "None";
    }
    return health;
  }

  String getVehicleStatus() {
    String status;
    switch (vehicleStatusController.text) {
      case "out of stock":
        status = "OutOfService";
        break;
      case "active":
        status = "Active";
        break;
      default:
        status = "Active";
    }
    return status;
  }

  Future<void> postData({
    LatLng? location,
    List<File?> additionalImages = const [],
    File? mainImageFile,
  }) async {
    try {
      emit(AddVehicleLoading());

      // Validate required fields before making the request
      if (mainImageFile == null) {
        //print('Error: Main image file is required');
        emit(AddVehicleFailure('Main image file is required'));
        return;
      }

      FormData formData = FormData();
      formData.fields.addAll([
        MapEntry(ApiKey.vehicleSeatsNo, vehicleSeatsNoController.text),
        MapEntry(ApiKey.vehicleModel, vehicleModelController.text),
        MapEntry(ApiKey.vehicleRentalPrice, vehicleRentalPrice.text),
        MapEntry(ApiKey.vehicleYearOfManufacture,
            vehicleYearOfManufactureController.text),
        MapEntry(ApiKey.vehicleColor, vehicleColorController.text),
        MapEntry(ApiKey.vehicleProperitesOverview,
            vehicleProperitesOverviewController.text),
        MapEntry(ApiKey.vehicleType, vehicleTypeController.text),
        MapEntry(ApiKey.vehicleBrand, vehicleBrandController.text),
        MapEntry(ApiKey.vehicleStatus, getVehicleStatus()),
        MapEntry(ApiKey.vehicleTransmissionMode, getVehicleTransmission()),
        MapEntry(ApiKey.vehicleHealth, getVehicleHealth()),
        MapEntry(
            ApiKey.vehicleLocationLatitude, (location?.latitude).toString()),
        MapEntry(
            ApiKey.vehicleLocationLongitude, (location?.longitude).toString()),
        MapEntry(ApiKey.vehicleAddress, vehicleAddressController.text),
      ]);
      // Add main image
      formData.files.add(MapEntry(
        ApiKey.vehicleMainImage,
        await MultipartFile.fromFile(
          mainImageFile.path,
          filename: basename(mainImageFile.path),
        ),
      ));
      if (additionalImages.isNotEmpty) {
        // print('Additional Images Count: ${additionalImages.length}');
        for (int i = 0; i < additionalImages.length; i++) {
          if (additionalImages[i] != null) {
            print(additionalImages[i]);
            formData.files.add(MapEntry(
              ApiKey.vehicleImages,
              await MultipartFile.fromFile(
                additionalImages[i]!.path,
                filename: basename(additionalImages[i]!.path),
              ),
            ));
            //  print('Additional Image $i Path: ${additionalImages[i]!.path}');
          }
        }
      }
      //  print('API Endpoint: ${EndPoint.vehicle}');

      try {
        final response = await _dio.post(
          "https://aggarapi.runasp.net/api/vehicle/",
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );
        print('Full Response Data: ${response.data}');
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          //print('Request Successful');
          emit(AddVehicleSuccess(response.data));
        } else {
          // print('Request Failed');
          emit(AddVehicleFailure(
              "Error: ${response.statusCode} - ${response.data.toString()}"));
        }
      } catch (networkError) {
        // print('Network Error: $networkError');
        rethrow;
      }
    } on DioException catch (e) {
      // Detailed Dio Exception logging
      // print('Dio Exception Type: ${e.type}');
      // print('Dio Exception Message: ${e.message}');

      String errorMessage = "Request failed";

      if (e.response != null) {
        // print('Error Response Status Code: ${e.response!.statusCode}');
        // print('Error Response Data: ${e.response!.data}');
        errorMessage =
            "Error ${e.response!.statusCode}: ${e.response!.data.toString()}";
      }

      // Handle specific Dio exception types
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = "Connection timeout";
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = "Receive timeout";
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = "Send timeout";
          break;
        case DioExceptionType.badResponse:
          errorMessage = "Bad response from server";
          break;
        default:
          errorMessage = "Error: ${e.message}";
      }

      // print('Final Error Message: $errorMessage');
      emit(AddVehicleFailure(errorMessage));
    } catch (e) {
      //print('Unexpected Error: $e');
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var vehicleData;
  ///////////////////////////////////////////////////////////////////////////////////////////
  Future<void> getData(String id) async {
    //print("Fetching vehicle data for ID: $id");
    try {
      emit(AddVehicleLoading());
      final response = await _dio.get(
        '${EndPoint.addVehicle}$id',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // Debug print of entire response
      // print('Full Response: ${response.data}');

      // Check if response has data
      if (response.data == null || response.data['data'] == null) {
        //print('No data found in response');
        emit(AddVehicleFailure('No vehicle data found'));
        return;
      }

      // Print raw JSON data before parsing
      print('Raw Vehicle JSON: ${response.data["data"]}');

      try {
        vehicleData = VehicleDataModel.fromJson(response.data["data"]);
        emit(AddVehicleSuccess(response.data));
      } catch (parseError) {
        // print('Error parsing vehicle data: $parseError');
        emit(AddVehicleFailure('Failed to parse vehicle data: $parseError'));
      }
    } on DioException catch (e) {
      String errorMessage = e.toString();
      //print('Dio Error: $errorMessage');
      emit(AddVehicleFailure(errorMessage));
    } catch (e) {
      //print('Unexpected error: $e');
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }
}
