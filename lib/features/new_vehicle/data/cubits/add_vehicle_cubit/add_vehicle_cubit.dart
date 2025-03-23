import 'dart:io';

import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart'
    show MainImageCubit;
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
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
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDUzIiwianRpIjoiZWFiYTJhYWYtYzE5NC00ODA1LTlkOWItMWVlMWJjYTE1Y2M0IiwidXNlcm5hbWUiOiJlc3JhYXRlc3Q4IiwidWlkIjoiMTA1MyIsInJvbGVzIjpbIlVzZXIiLCJSZW50ZXIiXSwiZXhwIjoxNzQyNzU2NTQxLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.1a-meZ0E3Iu1HuLYvbg60QhPsVZGibqBrOVkeoucGI8',
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

  Future<void> postData(
    LatLng? location,
    List<File?> additionalImages,
    File? mainImageFile,
  ) async {
    try {
      emit(AddVehicleLoading());
      FormData formData = FormData();

      // Create location JSON with default values if location is null
      final locationJson = jsonEncode({
        "Latitude": location?.latitude ?? 30.0444,
        "Longitude": location?.longitude ?? 31.2357,
      });

      formData.fields.addAll([
        MapEntry(ApiKey.vehicleSeatsNo, vehicleSeatsNoController.text),
        MapEntry(ApiKey.vehicleModel, vehicleModelController.text),
        MapEntry(ApiKey.vehicleRentalPrice, vehicleRentalPrice.text),
        MapEntry(ApiKey.vehicleYearOfManufacture,
            vehicleYearOfManufactureController.text),
        MapEntry(ApiKey.vehicleColor, vehicleColorController.text),
        MapEntry(ApiKey.vehicleProperitesOverview,
            vehicleProperitesOverviewController.text),
        MapEntry(ApiKey.vehicleType, "1"),
        MapEntry(ApiKey.vehicleBrand, "1"),
        MapEntry(ApiKey.vehicleStatus, vehicleStatusController.text),
        MapEntry(ApiKey.vehicleAddress, vehicleAddressController.text),
        MapEntry(ApiKey.vehicleTransmissionMode, "Manual"),
        MapEntry(ApiKey.vehicleHealth, selectedVehicleHealthValue ?? "Good"),
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
}
