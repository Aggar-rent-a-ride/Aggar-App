import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_brand_model.dart';
import 'package:equatable/equatable.dart';

abstract class AdminVehicleBrandState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminVehicleBrandInitial extends AdminVehicleBrandState {}

class AdminVehicleBrandLoading extends AdminVehicleBrandState {}

class AdminVehicleBrandLoaded extends AdminVehicleBrandState {
  final ListVehicleBrandModel listVehicleBrandModel;
  AdminVehicleBrandLoaded({required this.listVehicleBrandModel});
}

class AdminVehicleBrandError extends AdminVehicleBrandState {
  final String message;

  AdminVehicleBrandError({required this.message});

  @override
  List<Object?> get props => [message];
}
