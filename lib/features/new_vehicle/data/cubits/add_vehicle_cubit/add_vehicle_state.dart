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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleHealthUpdated &&
        other.selectedVehicleHealthValue == selectedVehicleHealthValue;
  }

  @override
  int get hashCode => selectedVehicleHealthValue.hashCode;
}

class AddVehicleFailure extends AddVehicleState {
  final String errorMessage;

  AddVehicleFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
