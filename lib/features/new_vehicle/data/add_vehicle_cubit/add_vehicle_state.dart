import 'package:equatable/equatable.dart';

abstract class AddVehicleState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleSuccess extends AddVehicleState {
  final String successMessage;

  AddVehicleSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class AddVehicleFailure extends AddVehicleState {
  final String errorMessage;

  AddVehicleFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
