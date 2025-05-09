import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleBrandState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleBrandInitial extends VehicleBrandState {}

class VehicleBrandLoading extends VehicleBrandState {}

class VehicleLoadedBrand extends VehicleBrandState {
  final ListVehicleModel? vehicles;

  VehicleLoadedBrand({this.vehicles});
}

class VehicleBrandError extends VehicleBrandState {
  final String message;

  VehicleBrandError({required this.message});

  @override
  List<Object?> get props => [message];
}
