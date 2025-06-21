import 'dart:io';
import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
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

  Map<String, dynamic>? responseData;
  int? vehicleId;
  VehicleDataModel? vehicleData;

  AddVehicleCubit(this.apiConsumer, this.mainImageCubit,
      this.additionalImageCubit, this.mapLocationCubit)
      : super(AddVehicleInitial()) {
    selectedTransmissionModeValue = 0; // Default to Automatic
    emit(TransmissionModeUpdated(selectedTransmissionModeValue!));
    emit(VehicleStatusUpdated(selectedVehicleStatusValue));

    _dio = Dio(BaseOptions(
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
  String? selectedVehicleHealthValue;

  void setTransmissionMode(int value) {
    selectedTransmissionModeValue = value;
    emit(TransmissionModeUpdated(selectedTransmissionModeValue!));
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

  void setVehicleHealth(String value) {
    selectedVehicleHealthValue = value;
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
    print("Current health value: $selectedVehicleHealthValue");
    if (selectedVehicleHealthValue == null) {
      return "Good"; // Default value that's acceptable to the API
    }

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

  Map<String, dynamic>? getResponseData() {
    return responseData;
  }

  String getVehicleId() {
    return vehicleId?.toString() ?? '';
  }

  Future<void> postData({
    required String token,
    LatLng? location,
    List<File?> additionalImages = const [],
    File? mainImageFile,
  }) async {
    print("Selected transmission mode: $selectedTransmissionModeValue");
    print("Transmission mode: ${getVehicleTransmission()}");
    print("Vehicle brand: ${vehicleBrandController.text}");
    try {
      emit(AddVehicleLoading());
      if (mainImageFile == null) {
        emit(const AddVehicleFailure('Main image file is required'));
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
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
            contentType: 'multipart/form-data',
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        responseData = response.data;

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          if (response.data != null && response.data['data'] != null) {
            try {
              vehicleData = VehicleDataModel.fromJson(response.data["data"]);
              vehicleId = response.data["data"]["id"];
              print("Successfully extracted vehicle ID: $vehicleId");
            } catch (parseError) {
              print('Error parsing vehicle data: $parseError');
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

  Future<void> getData(String id, String token) async {
    try {
      emit(AddVehicleLoading());
      final response = await _dio.get(
        '${EndPoint.addVehicle}$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      responseData = response.data;
      print("Response data: ${response.data}");
      vehicleData = VehicleDataModel.fromJson(response.data["data"]);
      vehicleId = response.data["data"]["id"];
      emit(AddVehicleSuccess(response.data));
    } catch (e) {
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }

  void reset() {
    // Reset data
    vehicleData = null;
    vehicleId = null;
    responseData = null;

    // Reset form controllers
    vehicleModelController.clear();
    vehicleRentalPrice.clear();
    vehicleYearOfManufactureController.clear();
    vehicleColorController.clear();
    vehicleSeatsNoController.clear();
    vehicleProperitesOverviewController.clear();
    vehicleBrandController.clear();
    vehicleTypeController.clear();
    vehicleStatusController.clear();
    vehicleAddressController.clear();

    // Reset state values
    selectedTransmissionModeValue = 0;
    selectedVehicleBrandValue = null;
    selectedVehicleTypeValue = null;
    selectedVehicleStatusValue = null;
    selectedVehicleBrandId = null;
    selectedVehicleTypeId = null;
    selectedVehicleHealthValue = null;

    // Emit initial states
    emit(AddVehicleInitial());
    emit(TransmissionModeUpdated(selectedTransmissionModeValue ?? 0));
    emit(VehicleStatusUpdated(selectedVehicleStatusValue));
    emit(VehicleHealthUpdated(selectedVehicleHealthValue));
    emit(VehicleBrandUpdated(selectedVehicleBrandValue));
    emit(VehicleTypeUpdated(selectedVehicleTypeValue));
  }
}
