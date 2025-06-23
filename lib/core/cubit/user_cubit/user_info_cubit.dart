import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/profile/data/model/user_info_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());
  final DioConsumer dio = DioConsumer(dio: Dio());

  Future<void> fetchUserInfo(String userId, String token) async {
    emit(UserInfoLoading());
    try {
      final response = await dio.get(
        EndPoint.getUserInfo,
        queryParameters: {"userId": userId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final userInfo = UserInfoModel.fromJson(response["data"]);
      print("User Info: $userInfo");
      emit(UserInfoSuccess(userInfoModel: userInfo));
    } catch (e) {
      emit(UserInfoError(errorMessage: e.toString()));
    }
  }
}
