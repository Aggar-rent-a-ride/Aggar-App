import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
 
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String accessToken;
  final String refreshToken;
  final String username;
 
  const LoginSuccess({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
  });
 
  @override
  List<Object> get props => [accessToken, refreshToken, username];
}

class LoginFailure extends LoginState {
  final String errorMessage;
 
  const LoginFailure({required this.errorMessage});
 
  @override
  List<Object> get props => [errorMessage];
}

class LoginPasswordVisibilityChanged extends LoginState {
  final bool obscurePassword;
 
  const LoginPasswordVisibilityChanged({required this.obscurePassword});
 
  @override
  List<Object> get props => [obscurePassword];
}

class LoginInactiveAccount extends LoginState {
  final Map<String, dynamic> userData;
  
  const LoginInactiveAccount({
    required this.userData,
  });
  
  @override
  List<Object> get props => [userData];
}