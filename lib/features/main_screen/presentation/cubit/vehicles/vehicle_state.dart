import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoadingMore extends VehicleState {
  final ListVehicleModel vehicles;

  const VehicleLoadingMore({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehicleLoaded extends VehicleState {
  final ListVehicleModel vehicles;

  const VehicleLoaded({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError({required this.message});

  @override
  List<Object?> get props => [message];
}
