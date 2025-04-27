import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final DioConsumer dioConsumer;
  final FlutterSecureStorage? secureStorage;

  // Renamed to identifierController to handle both email and username
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  Map<String, dynamic>? userData;

  LoginCubit({
    required this.dioConsumer,
    this.secureStorage,
  }) : super(LoginInitial());

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginPasswordVisibilityChanged(obscurePassword: obscurePassword));
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      login(
        identifier: identifierController.text,
        password: passwordController.text,
      );
    }
  }

  Future<void> login({required String identifier, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await dioConsumer.post(
        EndPoint.login,
        data: {
          "usernameOrEmail": identifier,
          "password": password,
        },
      );

      if (response == null) {
        emit(const LoginFailure(
            errorMessage: "No response received from server."));
        return;
      }

      final data = response['data'];
      if (data == null) {
        String errorMessage =
            response['message'] ?? "Invalid response format from server.";
        emit(LoginFailure(errorMessage: errorMessage));
        return;
      }

      userData = response;

      if (data[ApiKey.isAuthenticated] == true) {
        final accountStatus = data['accountStatus'];
        if (accountStatus == 'inactive') {
          emit(LoginInactiveAccount(userData: response));
          return;
        }

        final accessToken = data[ApiKey.accessToken] ?? "";
        final refreshToken = data[ApiKey.refreshToken] ?? "";

        await _storeTokens(
            accessToken: accessToken, refreshToken: refreshToken);

        emit(LoginSuccess(
          accessToken: accessToken,
          refreshToken: refreshToken,
          username: _extractUsername(data, identifier),
        ));
      } else {
        final errorMessage = _extractErrorMessage(response);
        emit(LoginFailure(errorMessage: errorMessage));
      }
    } catch (e) {
      emit(LoginFailure(
        errorMessage: "Connection error: ${e.toString()}",
      ));
    }
  }

  Future<void> _storeTokens(
      {required String accessToken, required String refreshToken}) async {
    try {
      if (secureStorage == null) {
        print('Secure storage is not initialized.');
        return;
      }
      if (accessToken.isEmpty || refreshToken.isEmpty) {
        print('Cannot store empty tokens.');
        return;
      }
      await Future.wait([
        secureStorage!.write(key: 'accessToken', value: accessToken),
        secureStorage!.write(key: 'refreshToken', value: refreshToken),
        secureStorage!.write(
            key: 'tokenCreatedAt', value: DateTime.now().toIso8601String())
      ]);

      print('Tokens stored successfully');
    } catch (e) {
      print('Detailed token storage error: $e');

      if (e is MissingPluginException) {
        print('Flutter Secure Storage plugin not properly configured.');
      }
    }
  }

  String _extractUsername(dynamic data, String identifier) {
    // If username is available in the response data, use it
    if (data[ApiKey.username] != null) {
      return data[ApiKey.username];
    }
    
    // If the identifier is an email, extract the username part
    if (identifier.contains('@')) {
      return identifier.split('@')[0];
    }
    
    // Otherwise, return the identifier as is (username)
    return identifier;
  }

  String _extractErrorMessage(dynamic response) {
    if (response['message'] != null) {
      return response['message'];
    }

    if (response['data'] != null && response['data']['message'] != null) {
      return response['data']['message'];
    }

    if (response['statusCode'] != null && response['statusCode'] != 200) {
      return "Login failed with status code: ${response['statusCode']}";
    }

    return "Login failed. Please check your credentials.";
  }

  @override
  Future<void> close() {
    identifierController.dispose();
    passwordController.dispose();
    return super.close();
  }
}