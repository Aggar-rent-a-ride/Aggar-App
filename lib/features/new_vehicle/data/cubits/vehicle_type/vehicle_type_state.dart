import 'package:equatable/equatable.dart';

abstract class VehicleTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleTypeInitial extends VehicleTypeState {}

class VehicleTypeLoading extends VehicleTypeState {}

class VehicleTypeLoaded extends VehicleTypeState {}

class VehicleTypeError extends VehicleTypeState {
  final String message;

  VehicleTypeError({required this.message});

  @override
  List<Object?> get props => [message];
}
