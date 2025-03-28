import 'package:equatable/equatable.dart';

abstract class TokenRefreshState extends Equatable {
  const TokenRefreshState();
 
  @override
  List<Object?> get props => [];
}

class TokenRefreshInitial extends TokenRefreshState {}

class TokenRefreshLoading extends TokenRefreshState {}

class TokenRefreshSuccess extends TokenRefreshState {
  final String accessToken;
  final String refreshToken;
  final DateTime? expirationDate;

  const TokenRefreshSuccess({
    required this.accessToken,
    required this.refreshToken,
    this.expirationDate,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expirationDate];
}

class TokenRefreshFailure extends TokenRefreshState {
  final String errorMessage;

  const TokenRefreshFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}