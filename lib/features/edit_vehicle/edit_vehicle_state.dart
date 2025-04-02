import 'dart:io';

import 'package:aggar/features/new_vehicle/data/model/vehicle_model.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class EditVehicleState extends Equatable {
  const EditVehicleState();

  @override
  List<Object?> get props => [];
}

class EditVehicleInitial extends EditVehicleState {}

class EditVehicleLoading extends EditVehicleState {}

class EditVehicleSuccess extends EditVehicleState {
  final dynamic response;

  const EditVehicleSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class EditVehicleFailure extends EditVehicleState {
  final String errorMessage;

  const EditVehicleFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class EditVehicleDataLoaded extends EditVehicleState {
  final VehicleDataModel vehicleData;

  const EditVehicleDataLoaded(this.vehicleData);

  @override
  List<Object?> get props => [vehicleData];
}

class TransmissionModeEdited extends EditVehicleState {
  final int? value;

  const TransmissionModeEdited(this.value);

  @override
  List<Object?> get props => [value];
}

class VehicleBrandEdited extends EditVehicleState {
  final String? value;

  const VehicleBrandEdited(this.value);

  @override
  List<Object?> get props => [value];
}

class VehicleStatusEdited extends EditVehicleState {
  final String? value;

  const VehicleStatusEdited(this.value);

  @override
  List<Object?> get props => [value];
}

class VehicleTypeEdited extends EditVehicleState {
  final String? value;

  const VehicleTypeEdited(this.value);

  @override
  List<Object?> get props => [value];
}

class VehicleHealthEdited extends EditVehicleState {
  final String? value;

  const VehicleHealthEdited(this.value);

  @override
  List<Object?> get props => [value];
}

class MainImageEdited extends EditVehicleState {
  final File imageFile;

  const MainImageEdited(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class AdditionalImagesEdited extends EditVehicleState {
  final List<File?> imageFiles;

  const AdditionalImagesEdited(this.imageFiles);

  @override
  List<Object?> get props => [imageFiles];
}

class LocationEdited extends EditVehicleState {
  final LatLng location;
  final String address;

  const LocationEdited(this.location, this.address);

  @override
  List<Object?> get props => [location, address];
}
