import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/profile/data/model/user_info_model.dart';
import 'package:aggar/features/profile/presentation/cubit/profile/profile_state.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main_screen/customer/data/model/list_vehicle_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  ProfileCubit() : super(ProfileInitial());

  Future<void> getCustomerFavouriteVehicles(String token) async {
    emit(ProfileLoading());
    try {
      final response = await dioConsumer.get(
        EndPoint.getFavouriteVehicles,
        queryParameters: {
          "pageNo": 1,
          "pageSize": 10,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      final listVehicleModel = ListVehicleModel.fromJson(response);
      emit(ProfileGetFavoriteSuccess(listVehicleModel: listVehicleModel));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> getRenterVehicles(String token) async {
    emit(ProfileLoading());
    try {
      final response = await dioConsumer.get(
        EndPoint.getRenterVehicles,
        queryParameters: {
          "pageNo": 1,
          "pageSize": 10,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      final listVehicleModel = ListVehicleModel.fromJson(response);
      emit(ProfileVehiclesSuccess(listVehicleModel: listVehicleModel));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> getUserInfo(String userId, String token) async {
    emit(ProfileLoading());
    try {
      final response = await dioConsumer.get(
        EndPoint.getUserInfo,
        queryParameters: {
          "userId": userId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      final userInfoModel = UserInfoModel.fromJson(response["data"]);
      print(userInfoModel);
      emit(ProfileUserInfoSuccess(userInfoModel: userInfoModel));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }
}
