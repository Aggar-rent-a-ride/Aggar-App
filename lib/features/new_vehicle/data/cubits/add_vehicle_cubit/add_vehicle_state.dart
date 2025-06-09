import 'package:equatable/equatable.dart';

abstract class AddVehicleState extends Equatable {
  const AddVehicleState();

  @override
  List<Object?> get props => [];
}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleSuccess extends AddVehicleState {
  final Map<String, dynamic> responseData;

  const AddVehicleSuccess(this.responseData);

  @override
  List<Object?> get props => [responseData];
}

class VehicleHealthSelected extends AddVehicleState {
  final String? selectedVehicleHealthValue;

  const VehicleHealthSelected({this.selectedVehicleHealthValue});
}

class TransmissionModeUpdated extends AddVehicleState {
  final int value;

  const TransmissionModeUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class VehicleHealthUpdated extends AddVehicleState {
  final String? selectedVehicleHealthValue;

  const VehicleHealthUpdated(this.selectedVehicleHealthValue);
}

class VehicleStatusUpdated extends AddVehicleState {
  final String? value;

  const VehicleStatusUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class VehicleBrandUpdated extends AddVehicleState {
  final String? selectedVehicleBrandValue;

  const VehicleBrandUpdated(this.selectedVehicleBrandValue);
}

class VehicleTypeUpdated extends AddVehicleState {
  final String? selectedVehicleTypeValue;

  const VehicleTypeUpdated(this.selectedVehicleTypeValue);
}

class AddVehicleFailure extends AddVehicleState {
  final String message;

  const AddVehicleFailure(this.message);

  @override
  List<Object?> get props => [message];
}
