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

  // Add a variable to store the response data
  Map<String, dynamic>? responseData;

  AddVehicleCubit(this.apiConsumer, this.mainImageCubit,
      this.additionalImageCubit, this.mapLocationCubit)
      : super(AddVehicleInitial()) {
    selectedTransmissionModeValue = 0; // Default to Automatic
    emit(TransmissionModeUpdated(selectedTransmissionModeValue));
    emit(VehicleStatusUpdated(selectedVehicleStatusValue));
    // Initialize Dio with base URL and default options
    _dio = Dio(BaseOptions(
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiYTM5N2M5OWMtNDU0Yy00NDhhLThhOTYtOTJjYmMxM2ZhOWFhIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0Mzc2Nzc4NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.rnUtM_eX8sLV7NtCvN2pwv3a0HZAJVAex58c5f02orM',
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
  String? selectedVehicleTypeValue;
  String? selectedVehicleStatusValue;
  int? selectedVehicleBrandId;
  int? selectedVehicleTypeId;

  void setTransmissionMode(int value) {
    selectedTransmissionModeValue = value;
    emit(TransmissionModeUpdated(selectedTransmissionModeValue));
  }

  void setVehicleBrnd(String value, int id) {
    selectedVehicleBrandId = id;
    selectedVehicleBrandValue = value;
    vehicleBrandController.text = value;
    emit(VehicleBrandUpdated(selectedVehicleBrandValue));
  }

  void setVehicleStatus(String value) {
    selectedVehicleStatusValue = value;
    vehicleStatusController.text = value;
    emit(VehicleStatusUpdated(selectedVehicleStatusValue));
  }

  void setVehicleType(String value, int id) {
    selectedVehicleTypeId = id;
    selectedVehicleTypeValue = value;
    vehicleTypeController.text = value;
    emit(VehicleTypeUpdated(selectedVehicleTypeValue));
  }

  String? selectedVehicleHealthValue;

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

  void setVehicleHealth(String value) {
    selectedVehicleHealthValue = value;
    emit(VehicleHealthUpdated(selectedVehicleHealthValue));
  }

  String getVehicleHealth() {
    print("Current health value: $selectedVehicleHealthValue");
    if (selectedVehicleHealthValue == null) {
      return "Good"; // Default value that's acceptable to the API
    }

    // Only run the switch if we have a non-null value
    switch (selectedVehicleHealthValue) {
      case "Excellent":
        return "Excellent";
      case "Minor dents":
        return "Scratched";
      case "Good":
        return "Good";
      case "Not bad":
        return "NotBad";
      default:
        return "Good"; // Fallback to a valid value
    }
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

  // Method to access the full response data
  Map<String, dynamic>? getResponseData() {
    return responseData;
  }

  Future<void> postData({
    LatLng? location,
    List<File?> additionalImages = const [],
    File? mainImageFile,
  }) async {
    print("Selected vehicle type: $selectedTransmissionModeValue");
    print("Selected vehicle type: $getVehicleTransmission()");
    print(vehicleBrandController.text);
    try {
      emit(AddVehicleLoading());
      if (mainImageFile == null) {
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
        MapEntry(ApiKey.vehicleType, selectedVehicleTypeId.toString()),
        MapEntry(ApiKey.vehicleBrand, selectedVehicleBrandId.toString()),
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
          }
        }
      }
      print("vehicleTypeId: $selectedVehicleTypeId");
      print("vehicleBrandId: $selectedVehicleBrandId");
      print("vehicleHealth: ${getVehicleHealth()}");
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

        // Store the full response data
        responseData = response.data;

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          // Parse the response and store vehicle data if available
          if (response.data != null && response.data['data'] != null) {
            try {
              vehicleData = VehicleDataModel.fromJson(response.data["data"]);
            } catch (parseError) {
              print('Error parsing vehicle data: $parseError');
              // Continue with success emission even if parsing fails
            }
          }
          emit(AddVehicleSuccess(response.data));
        } else {
          emit(AddVehicleFailure(
              "Error: ${response.statusCode} - ${response.data.toString()}"));
        }
      } catch (networkError) {
        rethrow;
      }
    } on DioException catch (e) {
      String errorMessage = "Request failed";

      if (e.response != null) {
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

      emit(AddVehicleFailure(errorMessage));
    } catch (e) {
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var vehicleData;
  ///////////////////////////////////////////////////////////////////////////////////////////
  Future<void> getData(String id) async {
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

      // Store the full response data
      responseData = response.data;

      // Check if response has data
      if (response.data == null || response.data['data'] == null) {
        emit(AddVehicleFailure('No vehicle data found'));
        return;
      }

      // Print raw JSON data before parsing
      print('Raw Vehicle JSON: ${response.data["data"]}');

      try {
        vehicleData = VehicleDataModel.fromJson(response.data["data"]);
        emit(AddVehicleSuccess(response.data));
      } catch (parseError) {
        emit(AddVehicleFailure('Failed to parse vehicle data: $parseError'));
      }
    } on DioException catch (e) {
      String errorMessage = e.toString();
      emit(AddVehicleFailure(errorMessage));
    } catch (e) {
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }
}
