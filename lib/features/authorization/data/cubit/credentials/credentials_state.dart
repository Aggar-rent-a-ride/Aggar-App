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
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  bool validatePassword() {
    return password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).+$')
            .hasMatch(password);
  }

  bool validateConfirmPassword() {
    return password == confirmPassword && confirmPassword.isNotEmpty;
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
