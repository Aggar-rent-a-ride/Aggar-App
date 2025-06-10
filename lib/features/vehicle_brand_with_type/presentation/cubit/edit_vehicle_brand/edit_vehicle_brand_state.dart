import 'dart:io';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_brand_model.dart';
import 'package:equatable/equatable.dart';

abstract class EditVehicleBrandState extends Equatable {
  const EditVehicleBrandState();

  @override
  List<Object?> get props => [];
}

class EditVehicleBrandInitial extends EditVehicleBrandState {}

class EditVehicleBrandLoading extends EditVehicleBrandState {}

class EditVehicleBrandUpdated extends EditVehicleBrandState {
  final VehicleBrandModel vehicleBrandModel;

  const EditVehicleBrandUpdated({required this.vehicleBrandModel});

  @override
  List<Object?> get props => [vehicleBrandModel];
}

class EditVehicleBrandError extends EditVehicleBrandState {
  final String message;

  const EditVehicleBrandError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EditVehicleBrandImageUpdated extends EditVehicleBrandState {
  final File? image;
  final String? imageUrl;

  const EditVehicleBrandImageUpdated({this.image, this.imageUrl});

  @override
  List<Object?> get props => [image, imageUrl];
}
