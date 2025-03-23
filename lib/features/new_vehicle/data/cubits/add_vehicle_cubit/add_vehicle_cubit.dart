import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart'
    show MainImageCubit;
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/end_points.dart';
import 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final MainImageCubit mainImageCubit;
  final AdditionalImageCubit additionalImageCubit;
  final MapLocationCubit mapLocationCubit;
  final ApiConsumer apiConsumer;
  AddVehicleCubit(this.apiConsumer, this.mainImageCubit,
      this.additionalImageCubit, this.mapLocationCubit)
      : super(AddVehicleInitial()) {
    selectedTransmissionModeValue = 0;
    emit(TransmissionModeUpdated(selectedTransmissionModeValue));
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

      final Map<String, dynamic> data = {
        ApiKey.vehicleModel: vehicleModelController.text, // Model
        ApiKey.vehicleRentalPrice: vehicleRentalPrice.text, // PricePerDay
        ApiKey.vehicleYearOfManufacture:
            vehicleYearOfManufactureController.text, // Year
        ApiKey.vehicleColor: vehicleColorController.text, // Color
        ApiKey.vehicleSeatsNo: vehicleSeatsNoController.text, // NumOfPassengers
        ApiKey.vehicleProperitesOverview:
            vehicleProperitesOverviewController.text, // ExtraDetails
        ApiKey.vehicleBrand: vehicleBrandController.text, // VehicleBrandId
        ApiKey.vehicleType: vehicleTypeController.text, // VehicleTypeId
        ApiKey.vehicleStatus: vehicleStatusController.text, // Status
        ApiKey.vehicleAddress: vehicleAddressController.text, // Address
        ApiKey.vehicleTransmissionMode:
            selectedTransmissionModeValue, // Transmission
        ApiKey.vehicleHealth: selectedVehicleHealthValue, // PhysicalStatus
        ApiKey.vehicleImages: additionalImageCubit.images, // Images
        ApiKey.vehicleMainImage: mainImageCubit.image, // MainImage
        ApiKey.vehiclLocation: mapLocationCubit.selectedLocation, // Location
      };
      final response = await apiConsumer.post(
        EndPoint.vehicle,
        data: data,
      );
    } catch (e) {}
  }
}
