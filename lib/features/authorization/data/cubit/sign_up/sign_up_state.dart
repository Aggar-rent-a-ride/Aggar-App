import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final Map<String, dynamic> userData;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const SignUpState({
    this.userData = const {},
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  SignUpState copyWith({
    Map<String, dynamic>? userData,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return SignUpState(
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [userData, isLoading, error, isSuccess];
}
