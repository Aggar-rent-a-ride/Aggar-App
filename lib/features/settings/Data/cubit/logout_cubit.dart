import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:dio/dio.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final DioConsumer dioConsumer;
  final FlutterSecureStorage secureStorage;

  LogoutCubit({
    required this.dioConsumer,
    required this.secureStorage,
  }) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final accessToken = await secureStorage.read(key: 'accessToken');
      final refreshToken = await secureStorage.read(key: 'refreshToken');

      if (accessToken == null || refreshToken == null) {
        await secureStorage.deleteAll();
        emit(LogoutSuccess(message: "Logged out successfully"));
        return;
      }
      final options = Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      final logoutPayload = {
        'refreshToken': refreshToken,
      };

      final response = await dioConsumer.post(
        EndPoint.logout,
        data: logoutPayload,
        options: options,
      );

      await secureStorage.deleteAll();
      String successMessage = "Logged out successfully";
      if (response != null) {
        if (response is Map) {
          successMessage = response['message'] ?? successMessage;
        } else if (response is String && response.isNotEmpty) {
          successMessage = response;
        }
      }

      emit(LogoutSuccess(message: successMessage));
    } on DioException catch (e) {
      await _handleDioError(e);
    } catch (error) {
      await secureStorage.deleteAll();
      emit(LogoutFailure(
          errorMessage: "Logout encountered an error: ${error.toString()}"));
    }
  }

  Future<void> _handleDioError(DioException error) async {
    await secureStorage.deleteAll();

    String errorMessage = "Network error during logout";
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map) {
        errorMessage = data['message'] ??
            data['error'] ??
            "Server error (${error.response!.statusCode})";
      } else if (data is String && data.isNotEmpty) {
        errorMessage = data;
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      errorMessage =
          "Connection timeout. Please check your internet connection.";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Server took too long to respond.";
    }

    emit(LogoutFailure(errorMessage: errorMessage));
  }
}
