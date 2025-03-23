import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart'
    show MainImageCubit;
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDUxIiwianRpIjoiNjRhYmE1NzctZGQwOC00ZTVlLWFhY2YtNDJkMDc3ZTA5YmI0IiwidXNlcm5hbWUiOiJlc3JhYXRlc3Q2IiwidWlkIjoiMTA1MSIsInJvbGVzIjpbIlVzZXIiLCJSZW50ZXIiXSwiZXhwIjoxNzQyNzQ3NTI4LCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.3d-hJG5qZ1UHgZR0KBYAPtpLQNauPP27vZOpd29UREo',
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

  Future<void> postData() async {
    try {
      emit(AddVehicleLoading());

      // Create FormData object
      FormData formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry(ApiKey.vehicleModel, vehicleModelController.text),
        MapEntry(ApiKey.vehicleRentalPrice, vehicleRentalPrice.text),
        MapEntry(ApiKey.vehicleYearOfManufacture,
            vehicleYearOfManufactureController.text),
        MapEntry(ApiKey.vehicleColor, vehicleColorController.text),
        MapEntry(ApiKey.vehicleSeatsNo, vehicleSeatsNoController.text),
        MapEntry(ApiKey.vehicleProperitesOverview,
            vehicleProperitesOverviewController.text),
        MapEntry(ApiKey.vehicleBrand, vehicleBrandController.text),
        MapEntry(ApiKey.vehicleType, vehicleTypeController.text),
        MapEntry(ApiKey.vehicleStatus, vehicleStatusController.text),
        MapEntry(ApiKey.vehicleAddress, vehicleAddressController.text),
      ]);
      // Send the request
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
      print("dddddddddddddddddd $response ");
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
