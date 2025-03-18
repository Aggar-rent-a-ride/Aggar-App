import 'package:equatable/equatable.dart';

class VerificationState extends Equatable {
  final String? email;
  final String code;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final int userId;
  final bool isResending;

  const VerificationState({
    this.email,
    this.code = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.userId = 0,
    this.isResending = false,
  });

  bool get isFormValid => code.length == 6;

  VerificationState copyWith({
    String? email,
    String? code,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    int? userId,
    bool? isResending,
  }) {
    return VerificationState(
      email: email ?? this.email,
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
      isResending: isResending ?? this.isResending,
    );
  }

  @override
  List<Object?> get props => [
        email,
        code,
        isLoading,
        isSuccess,
        errorMessage,
        userId,
        isResending,
      ];
}
