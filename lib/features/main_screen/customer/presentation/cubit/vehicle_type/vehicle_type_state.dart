import 'package:equatable/equatable.dart';

import '../../../data/model/list_vehicle_model.dart';

abstract class VehicleTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleTypeInitial extends VehicleTypeState {}

class VehicleTypeLoading extends VehicleTypeState {}

class VehicleLoadedType extends VehicleTypeState {
  final ListVehicleModel? vehicles;

  VehicleLoadedType({this.vehicles});
}

class VehicleTypeError extends VehicleTypeState {
  final String message;

  VehicleTypeError({required this.message});

  @override
  List<Object?> get props => [message];
}
