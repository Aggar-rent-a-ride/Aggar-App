import 'package:flutter_bloc/flutter_bloc.dart';
import 'credentials_state.dart';

class CredentialsCubit extends Cubit<CredentialsState> {
  CredentialsCubit() : super(const CredentialsState());

  void updateEmail(String email) {
    final newState = state.copyWith(
      email: email,
      isFormValid: _checkFormValidity(email: email),
    );
    emit(newState);
  }

  void updatePassword(String password) {
    final newState = state.copyWith(
      password: password,
      isFormValid: _checkFormValidity(password: password),
    );
    emit(newState);
  }

  void updateConfirmPassword(String confirmPassword) {
    final newState = state.copyWith(
      confirmPassword: confirmPassword,
      isFormValid: _checkFormValidity(confirmPassword: confirmPassword),
    );
    emit(newState);
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible));
  }

  bool _checkFormValidity({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    final currentEmail = email ?? state.email;
    final currentPassword = password ?? state.password;
    final currentConfirmPassword = confirmPassword ?? state.confirmPassword;

    return currentEmail.isNotEmpty &&
        currentPassword.isNotEmpty &&
        currentConfirmPassword.isNotEmpty &&
        currentPassword == currentConfirmPassword;
  }
}