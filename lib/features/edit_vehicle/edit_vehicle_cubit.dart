import 'dart:io';

import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart'
    show MainImageCubit;
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/model/location_model.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_brand_model.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_model.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_type_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' show basename;
import '../../../../../core/api/end_points.dart';
import 'edit_vehicle_state.dart';

class EditVehicleCubit extends Cubit<EditVehicleState> {
  final MainImageCubit mainImageCubit;
  final AdditionalImageCubit additionalImageCubit;
  final MapLocationCubit mapLocationCubit;
  final ApiConsumer apiConsumer;
  late Dio _dio;
  String? vehicleId;

  EditVehicleCubit(this.apiConsumer, this.mainImageCubit,
      this.additionalImageCubit, this.mapLocationCubit)
      : super(EditVehicleInitial()) {
    // Initialize Dio with base URL and default options
    _dio = Dio(BaseOptions(
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiZTQ2NjU0M2UtZTQyMS00OWMzLTg4NWItZjlmNWFlOWJjMjczIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzcwMDc3MywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.pjyBdvBEnilOQ1mLLGI31wFALUNw02IgeyRmZXyPueI',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
    ));
  }

  // Form Controllers
  GlobalKey<FormState> editVehicleFormKey = GlobalKey();
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

  // Selected Values
  int? selectedTransmissionModeValue;
  String? selectedVehicleBrandValue;
  int? selectedVehicleBrandId;
  int? selectedVehicleTypeId;
  String? selectedVehicleStatusValue;
  String? selectedVehicleTypeValue;
  String? selectedVehicleHealthValue;

  // Images
  File? mainImageFile;
  List<File?> additionalImagesFiles = [];
  List<String?> existingAdditionalImagesUrls = [];
  String? mainImageUrl;

  // Location
  LatLng? selectedLocation;

  void initWithVehicleData(VehicleDataModel vehicle, String id) {
    vehicleId = id;
    int transmissionValue = getTransmissionModeValue(vehicle.transmission);
    print(
        "Setting initial transmission value: $transmissionValue from ${vehicle.transmission}");
    setTransmissionMode(transmissionValue);
    emit(TransmissionModeEdited(selectedTransmissionModeValue));
    vehicleModelController.text = vehicle.model;
    vehicleRentalPrice.text = (vehicle.pricePerDay.toString());
    vehicleYearOfManufactureController.text = vehicle.year.toString();
    vehicleColorController.text = vehicle.color;
    vehicleSeatsNoController.text = vehicle.numOfPassengers.toString();
    vehicleProperitesOverviewController.text = vehicle.extraDetails ?? '';
    vehicleBrandController.text = vehicle.vehicleBrand.name;
    vehicleTypeController.text = vehicle.vehicleType.name;
    vehicleStatusController.text =
        vehicle.status == "OutOfService" ? "out of stock" : "active";
    vehicleAddressController.text = vehicle.address;
    mainImageUrl = vehicle.mainImagePath;
    if (mainImageUrl != null && mainImageUrl!.isNotEmpty) {
      mainImageCubit.setImageUrl(mainImageUrl!);
    }
    // Set selected values
    setTransmissionMode(getTransmissionModeValue(vehicle.transmission));
    setVehicleBrand(vehicle.vehicleBrand.name, vehicle.vehicleBrand.id);
    setVehicleStatus(
        vehicle.status == "OutOfService" ? "out of stock" : "active");
    setVehicleType(vehicle.vehicleType.name, vehicle.vehicleType.id);
    setVehicleHealth(_getVehicleHealthValue(vehicle.physicalStatus));

    // Set location
    selectedLocation =
        LatLng(vehicle.location.latitude, vehicle.location.longitude);
    mapLocationCubit.updateSelectedLocation(selectedLocation!);

    // Set image URLs
    mainImageUrl = vehicle.mainImagePath;
    if (vehicle.vehicleImages.isNotEmpty) {
      existingAdditionalImagesUrls = vehicle.vehicleImages;
    }

    emit(EditVehicleDataLoaded(vehicle));
  }

  // Helper method to convert transmission mode string to int value
  int getTransmissionModeValue(String? transmissionMode) {
    switch (transmissionMode) {
      case "Manual":
        return 2;
      case "Automatic":
        return 1;
      default:
        return 0;
    }
  }

  // Helper method to get health value from string
  String _getVehicleHealthValue(String? health) {
    switch (health) {
      case "Excellent":
        return "Excellent";
      case "Scratched":
        return "Minor dents";
      case "Good":
        return "Good";
      case "NotBad":
        return "Not bad";
      default:
        return "";
    }
  }

  void setTransmissionMode(int value) {
    print("Cubit updating transmission mode to: $value");
    selectedTransmissionModeValue = value;
    emit(TransmissionModeEdited(value));
  }

  void setVehicleBrand(String value, int id) {
    selectedVehicleBrandValue = value;
    selectedVehicleBrandId = id;
    vehicleBrandController.text = value;
    emit(VehicleBrandEdited(selectedVehicleBrandValue));
  }

  void setVehicleStatus(String value) {
    selectedVehicleStatusValue = value;
    vehicleStatusController.text = value;
    emit(VehicleStatusEdited(selectedVehicleStatusValue));
  }

  void setVehicleType(String value, int id) {
    selectedVehicleTypeValue = value;
    selectedVehicleTypeId = id;
    vehicleTypeController.text = value;
    emit(VehicleTypeEdited(selectedVehicleTypeValue));
  }

  void setVehicleHealth(String value) {
    if (value == selectedVehicleHealthValue) {
      return;
    }
    if (selectedVehicleHealthValue == value) {
      selectedVehicleHealthValue = null;
    } else {
      selectedVehicleHealthValue = value;
    }
    emit(VehicleHealthEdited(selectedVehicleHealthValue));
  }

  // Value Transformation Helper Methods
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

  void setMainImageFile(File file) {
    mainImageFile = file;
    mainImageCubit.updateImage(file);
    emit(MainImageEdited(file));
  }

  void addAdditionalImageFile(File file) {
    additionalImagesFiles.add(file);
    additionalImageCubit.images.add(file);
    emit(AdditionalImagesEdited(additionalImagesFiles));
  }

  void removeAdditionalImageFile(int index) {
    if (index >= 0 && index < additionalImagesFiles.length) {
      additionalImagesFiles.removeAt(index);
      additionalImageCubit.removeImageAt(index);
      emit(AdditionalImagesEdited(additionalImagesFiles));
    }
  }

  Future<void> fetchVehicleData(String id) async {
    try {
      emit(EditVehicleLoading());
      final response = await _dio.get(
        '${EndPoint.addVehicle}$id',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.data == null) {
        emit(const EditVehicleFailure('No response data found'));
        return;
      }
      var data = response.data;
      if (response.data['data'] != null) {
        data = response.data['data'];
      }

      print('Processing vehicle data: $data');
      try {
        final vehicle = VehicleDataModel(
          id: data['id'],
          model: data['model'],
          pricePerDay: data['pricePerDay'],
          year: data['year'],
          color: data['color'],
          numOfPassengers: data['numOfPassengers'],
          extraDetails: data['extraDetails'] ?? "",
          address: data['address'],
          status: data['status'],
          physicalStatus: data['physicalStatus'],
          transmission: data['transmission'],
          mainImagePath: data['mainImagePath'],
          vehicleBrand: VehicleBrand.fromJson(data['vehicleBrand']),
          vehicleType: VehicleType.fromJson(data['vehicleType']),
          location: LocationModel.fromJson(data['location']),
          vehicleImages: data['vehicleImages'] != null
              ? List<String>.from(data['vehicleImages']
                  .map((image) => image is String ? image : image.toString()))
              : [],
        );
        initWithVehicleData(vehicle, id);
      } catch (parseError) {
        emit(EditVehicleFailure('Failed to parse vehicle data: $parseError'));
      }
    } on DioException catch (e) {
      String errorMessage = e.toString();
      emit(EditVehicleFailure(errorMessage));
    } catch (e) {
      emit(EditVehicleFailure("Unexpected error: $e"));
    }
  }

  Future<void> updateVehicle(
    String id,
    LatLng? location,
    List<File?>? additionalImages,
    File? updatedMainImageFile,
  ) async {
    print(selectedVehicleBrandValue);
    if (vehicleId == null) {
      print(vehicleId);
      emit(const EditVehicleFailure('Vehicle ID is missing'));
      return;
    }
    try {
      emit(EditVehicleLoading());
      FormData formData = FormData();
      FormData formDataImages = FormData();

      // Make sure transmission mode is properly set
      String transmissionMode = getVehicleTransmission();
      print('Updating vehicle with transmission mode: $transmissionMode');

      formData.fields.addAll([
        MapEntry("Id", vehicleId!),
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
        MapEntry(ApiKey.vehicleTransmissionMode, transmissionMode),
        MapEntry(ApiKey.vehicleHealth, getVehicleHealth()),
        MapEntry(
            ApiKey.vehicleLocationLatitude, (location?.latitude).toString()),
        MapEntry(
            ApiKey.vehicleLocationLongitude, (location?.longitude).toString()),
        MapEntry(ApiKey.vehicleAddress, vehicleAddressController.text),
      ]);
      if (updatedMainImageFile != null) {
        formData.files.add(MapEntry(
          ApiKey.vehicleMainImage,
          await MultipartFile.fromFile(
            updatedMainImageFile.path,
            filename: basename(updatedMainImageFile.path),
          ),
        ));
      }
      formDataImages.fields.add(
        MapEntry("VehicleId", vehicleId!),
      );
      if (additionalImages != null && additionalImages.isNotEmpty) {
        for (int i = 0; i < additionalImages.length; i++) {
          if (additionalImages[i] != null) {
            formDataImages.files.add(MapEntry(
              "NewImages",
              await MultipartFile.fromFile(
                additionalImages[i]!.path,
                filename: basename(additionalImages[i]!.path),
              ),
            ));
          }
        }
      }

      final response = await _dio.put(
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
      // print(response.data);
      final ImagesResonse = await _dio.put(
        data: formDataImages,
        "https://aggarapi.runasp.net/api/vehicle/vehicle-images",
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(ImagesResonse.data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        emit(EditVehicleSuccess(response.data));
      } else {
        emit(EditVehicleFailure(
            "Error: ${response.statusCode} - ${response.data.toString()}"));
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

      emit(EditVehicleFailure(errorMessage));
    } catch (e) {
      emit(EditVehicleFailure("Unexpected error: $e"));
    }
  }
}
