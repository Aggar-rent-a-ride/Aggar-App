class CredentialsState {
  final String email;
  final String password;
  final String confirmPassword;
  final bool passwordVisible;
  final bool confirmPasswordVisible;

  const CredentialsState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
  });

  bool validateEmail() {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool validatePassword() {
    return password.length >= 6;
  }

  bool validateConfirmPassword() {
    return password == confirmPassword;
  }

  bool get isFormValid {
    return validateEmail() && validatePassword() && validateConfirmPassword();
  }

  CredentialsState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? passwordVisible,
    bool? confirmPasswordVisible,
  }) {
    return CredentialsState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible:
          confirmPasswordVisible ?? this.confirmPasswordVisible,
    );
  }
}
