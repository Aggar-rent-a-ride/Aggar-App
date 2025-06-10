import 'dart:io';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_type_model.dart';
import 'package:equatable/equatable.dart';

abstract class EditVehicleTypeState extends Equatable {
  const EditVehicleTypeState();

  @override
  List<Object?> get props => [];
}

class EditVehicleTypeInitial extends EditVehicleTypeState {}

class EditVehicleTypeLoading extends EditVehicleTypeState {}

class EditVehicleTypeUpdated extends EditVehicleTypeState {
  final VehicleTypeModel vehicleTypeModel;

  const EditVehicleTypeUpdated({required this.vehicleTypeModel});

  @override
  List<Object?> get props => [vehicleTypeModel];
}

class EditVehicleTypeError extends EditVehicleTypeState {
  final String message;

  const EditVehicleTypeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EditVehicleTypeImageUpdated extends EditVehicleTypeState {
  final File? image;
  final String? imageUrl;

  const EditVehicleTypeImageUpdated({this.image, this.imageUrl});

  @override
  List<Object?> get props => [image, imageUrl];
}
