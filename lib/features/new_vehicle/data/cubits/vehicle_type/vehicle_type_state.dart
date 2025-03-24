import 'package:aggar/features/new_vehicle/data/model/vehicle_type_model.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class VehicleTypeInitial extends VehicleTypeState {}

// Loading state
class VehicleTypeLoading extends VehicleTypeState {}

// Loaded state
class VehicleTypeLoaded extends VehicleTypeState {}

// Error state
class VehicleTypeError extends VehicleTypeState {
  final String message;

  VehicleTypeError({required this.message});

  @override
  List<Object?> get props => [message];
}
