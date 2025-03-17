import 'package:equatable/equatable.dart';

abstract class AddVehicleState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleSuccess extends AddVehicleState {
  final String successMessage;

  AddVehicleSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class VehicleHealthSelected extends AddVehicleState {
  final String? selectedVehicleHealthValue;

  VehicleHealthSelected({this.selectedVehicleHealthValue});
}

class TransmissionModeUpdated extends AddVehicleState {
  final int? transmissionMode;

  TransmissionModeUpdated(this.transmissionMode);

  @override
  List<Object> get props => [transmissionMode ?? -1];
}

class VehicleHealthUpdated extends AddVehicleState {
  final String? selectedVehicleHealthValue;

  VehicleHealthUpdated(this.selectedVehicleHealthValue);
}

class VehicleStatusUpdated extends AddVehicleState {
  final String? selectedVehicleStatusValue;

  VehicleStatusUpdated(this.selectedVehicleStatusValue);
}

class VehicleBrandUpdated extends AddVehicleState {
  final String? selectedVehicleBrandValue;

  VehicleBrandUpdated(this.selectedVehicleBrandValue);
}

class VehicleTypeUpdated extends AddVehicleState {
  final String? selectedVehicleTypeValue;

  VehicleTypeUpdated(this.selectedVehicleTypeValue);
}

class AddVehicleFailure extends AddVehicleState {
  final String errorMessage;

  AddVehicleFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
