import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_brand_model.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_brand_model.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class AdminVehicleBrandState extends Equatable {
  const AdminVehicleBrandState();

  @override
  List<Object?> get props => [];
}

class AdminVehicleBrandInitial extends AdminVehicleBrandState {}

class AdminVehicleBrandLoading extends AdminVehicleBrandState {}

class AdminVehicleBrandLoaded extends AdminVehicleBrandState {
  final ListVehicleBrandModel listVehicleBrandModel;

  const AdminVehicleBrandLoaded({required this.listVehicleBrandModel});

  @override
  List<Object?> get props => [listVehicleBrandModel];
}

class AdminVehicleBrandAdded extends AdminVehicleBrandState {}

class AdminVehicleBrandUpdated extends AdminVehicleBrandState {
  final VehicleBrandModel vehicleBrandModel;

  const AdminVehicleBrandUpdated({required this.vehicleBrandModel});

  @override
  List<Object?> get props => [vehicleBrandModel];
}

class AdminVehicleBrandDeleted extends AdminVehicleBrandState {}

class AdminVehicleBrandError extends AdminVehicleBrandState {
  final String message;

  const AdminVehicleBrandError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminVehicleBrandImageUpdated extends AdminVehicleBrandState {
  final File? image;
  final String? imageUrl;

  const AdminVehicleBrandImageUpdated({this.image, this.imageUrl});

  @override
  List<Object?> get props => [image, imageUrl];
}
