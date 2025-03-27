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

    // Initialize Dio with base URL and default options
    _dio = Dio(BaseOptions(
      baseUrl: "https://aggarapi.runasp.net",
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDU3IiwianRpIjoiZTRkZWFkMTUtNWYyNS00MzFlLWEwMzMtYmVkNzZjMzIzZmEwIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMCIsInVpZCI6IjEwNTciLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzEwODMxMCwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.uCuZwbjfX05Qe5Px3Tj6ai1SkfxAUZtzBxX4E2D9hnU',
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

  void setTransmissionMode(int value) {
    selectedTransmissionModeValue = value;
    emit(TransmissionModeUpdated(selectedTransmissionModeValue));
  }

  String? selectedVehicleBrandValue;
  void setVehicleBrand(String value) {
    selectedVehicleBrandValue = value;
    vehicleBrandController.text = value;
    emit(VehicleBrandUpdated(selectedVehicleBrandValue));
  }

  String? selectedVehicleStatusValue;
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
      case 0:
        transmissionMode = "None";
        break;
      case 1:
        transmissionMode = "Manual";
        break;
      default:
        transmissionMode = "Automatic";
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
    switch (selectedVehicleStatusValue) {
      case "out of stock":
        status = "OutOfService";
        break;
      default:
        status = "Active";
    }
    return status;
  }

  Future<void> postData(
    LatLng? location,
    List<File?> additionalImages,
    File? mainImageFile,
  ) async {
    try {
      emit(AddVehicleLoading());
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
        MapEntry(ApiKey.vehicleType, selectedVehicleTypeValue ?? "1"),
        MapEntry(ApiKey.vehicleBrand, selectedVehicleBrandValue ?? "1"),
        MapEntry(ApiKey.vehicleStatus, getVehicleStatus()),
        MapEntry(ApiKey.vehicleAddress, vehicleAddressController.text),
        MapEntry(ApiKey.vehicleTransmissionMode, getVehicleTransmission()),
        MapEntry(ApiKey.vehicleHealth, getVehicleHealth()),
        MapEntry(
            "Location.Latitude", (location?.latitude ?? 30.0444).toString()),
        MapEntry(
            "Location.Longitude", (location?.longitude ?? 31.2357).toString()),
      ]);
      formData.files.add(MapEntry(
        "MainImage",
        await MultipartFile.fromFile(
          mainImageFile!.path,
          filename: basename(mainImageFile.path),
        ),
      ));
      if (additionalImages.isNotEmpty) {
        for (int i = 0; i < additionalImages.length; i++) {
          if (additionalImages[i] != null) {
            formData.files.add(MapEntry(
              "AdditionalImages",
              await MultipartFile.fromFile(
                additionalImages[i]!.path,
                filename: basename(additionalImages[i]!.path),
              ),
            ));
          }
        }
      }

      final response = await _dio.post(
        EndPoint.vehicle,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print("Response: $response");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        emit(AddVehicleSuccess(response.data));
      } else {
        emit(AddVehicleFailure(
            "Error: ${response.statusCode} - ${response.data.toString()}"));
      }
    } on DioException catch (e) {
      String errorMessage = "Request failed";

      if (e.response != null) {
        errorMessage =
            "Error ${e.response!.statusCode}: ${e.response!.data.toString()}";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Receive timeout";
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = "Send timeout";
      } else {
        errorMessage = "Error: ${e.message}";
      }

      emit(AddVehicleFailure(errorMessage));
    } catch (e) {
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }

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
      //print(response.data["data"]);
      // ignore: unused_local_variable
      vehicleData = VehicleDataModel.fromJson(response.data["data"]);
      print(vehicleData);

      emit(AddVehicleSuccess(response.data));
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      emit(AddVehicleFailure(errorMessage));
    } catch (e) {
      emit(AddVehicleFailure("Unexpected error: $e"));
    }
  }

  // Helper method to handle Dio errors
  String _handleDioError(DioException e) {
    if (e.response != null) {
      return "Error ${e.response!.statusCode}: ${e.response!.data.toString()}";
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout";
      case DioExceptionType.sendTimeout:
        return "Send timeout";
      case DioExceptionType.badResponse:
        return "Bad response from server";
      case DioExceptionType.cancel:
        return "Request cancelled";
      default:
        return "Error: ${e.message}";
    }
  }
}
