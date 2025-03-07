import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  AddVehicleCubit() : super(AddVehicleInitial());
  GlobalKey<FormState> addVehicleFormKey = GlobalKey();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleYearOfManufactureController =
      TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController vehicleSeatsNoController = TextEditingController();
  TextEditingController vehicleProperitesOverviewController =
      TextEditingController();
  String? selectedValue;
}
