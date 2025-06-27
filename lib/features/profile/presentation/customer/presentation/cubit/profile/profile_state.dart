import 'package:aggar/features/main_screen/customer/data/model/list_vehicle_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileGetFavoriteSuccess extends ProfileState {
  final ListVehicleModel listVehicleModel;
  ProfileGetFavoriteSuccess({required this.listVehicleModel});
}

class ProfileVehiclesSuccess extends ProfileState {
  final ListVehicleModel listVehicleModel;
  ProfileVehiclesSuccess({required this.listVehicleModel});
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError({required this.errorMessage});
}

class ProfileFavoriteVehicleLoadingMore extends ProfileState {
  final ListVehicleModel listVehicleModel;
  ProfileFavoriteVehicleLoadingMore({required this.listVehicleModel});
}

class ProfileRenterVehicleLoadingMore extends ProfileState {
  final ListVehicleModel listVehicleModel;
  ProfileRenterVehicleLoadingMore({required this.listVehicleModel});
}
