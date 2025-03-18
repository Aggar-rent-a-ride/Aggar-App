import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'verification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VerificationCubit extends Cubit<VerificationState> {
  late final DioConsumer _apiConsumer;
  final Map<String, dynamic>? userData;

  VerificationCubit({this.userData}) : super(const VerificationState()) {
    _apiConsumer = DioConsumer(dio: Dio());

    // Extract user data from registration response
    if (userData != null && userData!['data'] != null) {
      final data = userData!['data'];
      emit(state.copyWith(
        email: data[ApiKey.email],
        userId: data[ApiKey.userId],
      ));

      // Send verification code right away
      sendVerificationCode();
    }
  }

  void updateCode(String code) {
    emit(state.copyWith(code: code));
  }

  void resetError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> sendVerificationCode() async {
    if (state.userId == 0) {
      emit(state.copyWith(
        errorMessage: 'User ID is missing. Please register again.',
      ));
      return;
    }

    emit(state.copyWith(isResending: true, errorMessage: null));

    try {
      final response = await _apiConsumer.post(
        EndPoint.sendActivationCode,
        queryParameters: {"userId": state.userId},
      );

      print('Verification code sent: $response');
      emit(state.copyWith(isResending: false));
    } on DioException catch (e) {
      print('Dio exception: ${e.message}');
      print('Response data: ${e.response?.data}');
      emit(state.copyWith(
        isResending: false,
        errorMessage:
            'Failed to send verification code: ${e.response?.data?.toString() ?? e.message}',
      ));
    } catch (error) {
      print('Verification code error: $error');
      emit(state.copyWith(
        isResending: false,
        errorMessage: 'Failed to send verification code: $error',
      ));
    }
  }

  Future<void> verifyCode() async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: 'Please enter the complete verification code.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await _apiConsumer.post(
        EndPoint.activate,
        data: {
          "userId": state.userId,
          "ActivationCode": state.code,
        },
      );

      print('Verification successful: $response');

      // Save user data to SharedPreferences
      await _saveUserData(response);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on DioException catch (e) {
      print('Dio exception: ${e.message}');
      print('Response data: ${e.response?.data}');
      emit(state.copyWith(
        isLoading: false,
        errorMessage:
            'Verification failed: ${e.response?.data?.toString() ?? e.message}',
      ));
    } catch (error) {
      print('Verification error: $error');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Verification failed: $error',
      ));
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> response) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (response['data'] != null) {
        // Save user info
        await prefs.setString('user_data', jsonEncode(response['data']));

        // Save token if available
        final accessToken = response['data'][ApiKey.accessToken];
        if (accessToken != null && accessToken.isNotEmpty) {
          await prefs.setString('access_token', accessToken);
        }

        // Save refresh token if available
        final refreshToken = response['data'][ApiKey.refreshToken];
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await prefs.setString('refresh_token', refreshToken);
        }

        // Set logged in status
        await prefs.setBool('is_logged_in', true);
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
