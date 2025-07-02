import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'credentials_state.dart';

class CredentialsCubit extends Cubit<CredentialsState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CredentialsCubit() : super(const CredentialsState());

  void updateEmail(String email) {
    emailController.text = email;
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    passwordController.text = password;
    emit(state.copyWith(password: password));
  }

  void updateConfirmPassword(String confirmPassword) {
    confirmPasswordController.text = confirmPassword;
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
