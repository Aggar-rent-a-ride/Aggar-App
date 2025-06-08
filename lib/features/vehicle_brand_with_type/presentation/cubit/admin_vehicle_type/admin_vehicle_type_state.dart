import 'dart:io';

import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_type_model.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_type_model.dart';
import 'package:equatable/equatable.dart';

abstract class AdminVehicleTypeState extends Equatable {
  const AdminVehicleTypeState();

  @override
  List<Object?> get props => [];
}

class AdminVehicleTypeInitial extends AdminVehicleTypeState {}

class AdminVehicleTypeLoading extends AdminVehicleTypeState {}

class AdminVehicleTypeLoaded extends AdminVehicleTypeState {
  final ListVehicleTypeModel listVehicleTypeModel;

  const AdminVehicleTypeLoaded(this.listVehicleTypeModel);

  @override
  List<Object?> get props => [listVehicleTypeModel];
}

class AdminVehicleTypeAdded extends AdminVehicleTypeState {}

class AdminVehicleTypeUpdated extends AdminVehicleTypeState {
  final VehicleTypeModel vehicletypeModel;

  const AdminVehicleTypeUpdated({required this.vehicletypeModel});

  @override
  List<Object?> get props => [vehicletypeModel];
}

class AdminVehicleTypeImageUpdated extends AdminVehicleTypeState {
  final File? image;
  final String? imageUrl;

  const AdminVehicleTypeImageUpdated({this.image, this.imageUrl});

  @override
  List<Object?> get props => [image, imageUrl];
}

class AdminVehicleTypeError extends AdminVehicleTypeState {
  final String message;

  const AdminVehicleTypeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminVehicleTypeDeleted extends AdminVehicleTypeState {}
