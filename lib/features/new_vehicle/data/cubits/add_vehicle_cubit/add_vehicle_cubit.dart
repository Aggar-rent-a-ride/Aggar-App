import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  AddVehicleCubit() : super(AddVehicleInitial()) {
    // Initialize with default value right after construction
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
}
