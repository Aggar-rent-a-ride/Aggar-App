import 'package:equatable/equatable.dart';

class CredentialsState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final bool isFormValid;
  final bool passwordVisible;
  final bool confirmPasswordVisible;

  const CredentialsState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isFormValid = false,
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
  });

  CredentialsState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isFormValid,
    bool? passwordVisible,
    bool? confirmPasswordVisible,
  }) {
    return CredentialsState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible: confirmPasswordVisible ?? this.confirmPasswordVisible,
    );
  }

  bool validateEmail() {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.isNotEmpty && emailRegExp.hasMatch(email);
  }

  bool validatePassword() {
    return password.isNotEmpty && password.length >= 6;
  }

  bool validateConfirmPassword() {
    return confirmPassword.isNotEmpty && password == confirmPassword;
  }

  @override
  List<Object> get props => [
    email, 
    password, 
    confirmPassword, 
    isFormValid, 
    passwordVisible, 
    confirmPasswordVisible
  ];
}