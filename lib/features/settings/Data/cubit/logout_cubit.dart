import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final DioConsumer dioConsumer;
  final FlutterSecureStorage secureStorage;

  LogoutCubit({
    required this.dioConsumer,
    required this.secureStorage,
  }) : super(LogoutInitial());

  Future<void> logout() async {
    try {
      emit(LogoutLoading());
      final refreshToken = await secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }
      final logoutPayload = {
        ApiKey.refreshToken: refreshToken,
      };

      final response = await dioConsumer.post(
        EndPoint.logout,
        data: logoutPayload,
      );

      if (response != null && response[ApiKey.status] == 200) {
        await secureStorage.deleteAll();
        emit(LogoutSuccess(
            message: response[ApiKey.message] ?? "Successfully logged out"));
      } else {
        throw Exception(response?[ApiKey.message] ?? 'Logout failed');
      }
    } catch (error) {
      emit(LogoutFailure(errorMessage: error.toString()));
    }
  }
}
