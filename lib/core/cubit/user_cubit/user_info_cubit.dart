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
      emit(UserInfoSuccess(userInfoModel: userInfo));
    } catch (e) {
      emit(UserInfoError(errorMessage: e.toString()));
    }
  }

  Future<void> editProfile(
      String userId,
      String token,
      String name,
      String image,
      String longitude,
      String latitude,
      String address,
      String dateOfBirth,
      String bio) async {
    emit(UserInfoLoading());
    try {
      final formData = FormData.fromMap({
        'name': name,
        'image': await MultipartFile.fromFile(image, filename: 'profile.jpg'),
        'Location.longitude': longitude,
        'Location.latitude': latitude,
        'address': address,
        'DateOfBirth': dateOfBirth,
        'bio': bio,
      });

      final response = await dio.put(
        '${EndPoint.baseUrl}/api/user/profile',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final updatedUserInfo = UserInfoModel.fromJson(response["data"]);
      emit(UserInfoSuccess(userInfoModel: updatedUserInfo));
    } catch (e) {
      emit(UserInfoError(errorMessage: e.toString()));
    }
  }
}
