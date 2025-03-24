import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final DioConsumer dioConsumer;
 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
 
  bool obscurePassword = true;

  LoginCubit({required this.dioConsumer}) : super(LoginInitial());

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginPasswordVisibilityChanged(obscurePassword: obscurePassword));
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      login(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await dioConsumer.post(
        EndPoint.login,
        data: {
          "usernameOrEmail": email,
          "password": password,
        },
      );
      
      // Check if response exists
      if (response == null) {
        emit(LoginFailure(errorMessage: "No response received from server."));
        return;
      }
      
      // Extract the data object which contains all the user information
      final data = response['data'];
      
      // Check if data exists
      if (data == null) {
        String errorMessage = response['message'] ?? "Invalid response format from server.";
        emit(LoginFailure(errorMessage: errorMessage));
        return;
      }
      
      // Check if authentication was successful
      if (data[ApiKey.isAuthenticated] == true) {
        emit(LoginSuccess(
          accessToken: data[ApiKey.accessToken] ?? "",
          refreshToken: data[ApiKey.refreshToken] ?? "",
          username: _extractUsername(data, email),
        ));
      } else {
        // Extract error message
        final errorMessage = _extractErrorMessage(response);
        emit(LoginFailure(errorMessage: errorMessage));
      }
    } catch (e) {
      emit(LoginFailure(
        errorMessage: "Connection error: ${e.toString()}",
      ));
    }
  }

  String _extractUsername(dynamic data, String email) {
    return data[ApiKey.username] ?? email.split('@')[0];
  }

  String _extractErrorMessage(dynamic response) {
    // Check for message in main response
    if (response['message'] != null) {
      return response['message'];
    }
    
    // Check for message in data object
    if (response['data'] != null && response['data']['message'] != null) {
      return response['data']['message'];
    }
    
    // Check for statusCode to provide more context
    if (response['statusCode'] != null && response['statusCode'] != 200) {
      return "Login failed with status code: ${response['statusCode']}";
    }
    
    return "Login failed. Please check your credentials.";
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
