import 'package:aggar/features/profile/data/model/user_info_model.dart';

abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoSuccess extends UserInfoState {
  final UserInfoModel userInfoModel;
  UserInfoSuccess({required this.userInfoModel});
}

class UserInfoError extends UserInfoState {
  final String errorMessage;
  UserInfoError({required this.errorMessage});
}
