import 'package:aggar/features/main_screen/customer/data/model/list_vehicle_model.dart';
import 'package:aggar/features/profile/data/model/user_info_model.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/list_review_model.dart';

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

class ProfileGetReviewSuccess extends ProfileState {
  final ListReviewModel listReviewModel;
  ProfileGetReviewSuccess({required this.listReviewModel});
}

class ProfileUserInfoSuccess extends ProfileState {
  final UserInfoModel userInfoModel;
  ProfileUserInfoSuccess({required this.userInfoModel});
}

class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError({required this.errorMessage});
}
