import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_type_model.dart';
import 'package:equatable/equatable.dart';

abstract class AdminVehicleTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminVehicleTypeInitial extends AdminVehicleTypeState {}

class AdminVehicleTypeLoading extends AdminVehicleTypeState {}

class AdminVehicleTypeLoaded extends AdminVehicleTypeState {
  final ListVehicleTypeModel listVehicleTypeModel;
  AdminVehicleTypeLoaded({required this.listVehicleTypeModel});
}

class AdminVehicleTypeDeleted extends AdminVehicleTypeState {}

class AdminVehicleTypeError extends AdminVehicleTypeState {
  final String message;

  AdminVehicleTypeError({required this.message});

  @override
  List<Object?> get props => [message];
}
