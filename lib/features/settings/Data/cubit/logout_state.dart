import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();
  
  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final String message;

  const LogoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutFailure extends LogoutState {
  final String errorMessage;

  const LogoutFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}