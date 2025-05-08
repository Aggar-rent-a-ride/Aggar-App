import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final ListVehicleModel vehicles;

  VehicleLoaded({required this.vehicles});
}

class VehicleError extends VehicleState {
  final String message;

  VehicleError({required this.message});

  @override
  List<Object?> get props => [message];
}
