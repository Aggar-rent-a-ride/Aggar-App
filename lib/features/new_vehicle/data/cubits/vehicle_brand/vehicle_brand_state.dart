import 'package:equatable/equatable.dart';

abstract class VehicleBrandState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleBrandInitial extends VehicleBrandState {}

class VehicleBrandLoading extends VehicleBrandState {}

class VehicleBrandLoaded extends VehicleBrandState {}

class VehicleBrandError extends VehicleBrandState {
  final String message;

  VehicleBrandError({required this.message});

  @override
  List<Object?> get props => [message];
}
