import 'dart:io';

import 'package:aggar/features/profile/data/model/user_info_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:equatable/equatable.dart';

abstract class EditUserInfoState extends Equatable {
  const EditUserInfoState();

  @override
  List<Object> get props => [];
}

class EditUserInfoInitial extends EditUserInfoState {}

class EditUserInfoLoading extends EditUserInfoState {}

class EditUserInfoSuccess extends EditUserInfoState {
  final UserInfoModel userInfoModel;

  const EditUserInfoSuccess({required this.userInfoModel});

  @override
  List<Object> get props => [userInfoModel];
}

class EditUserInfoError extends EditUserInfoState {
  final String errorMessage;

  const EditUserInfoError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class EditUserInfoLocationUpdated extends EditUserInfoState {
  final LatLng location;
  final String address;

  const EditUserInfoLocationUpdated(
      {required this.location, required this.address});

  @override
  List<Object> get props => [location, address];
}

class EditUserInfoImageUpdated extends EditUserInfoState {
  final File image;

  const EditUserInfoImageUpdated({required this.image});

  @override
  List<Object> get props => [image];
}
