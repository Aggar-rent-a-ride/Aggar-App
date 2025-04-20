import 'package:equatable/equatable.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

class MainScreenInitial extends MainScreenState {}

class MainScreenLoading extends MainScreenState {}

class MainScreenAuthenticated extends MainScreenState {
  final String accessToken;

  const MainScreenAuthenticated({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}

class MainScreenUnauthenticated extends MainScreenState {}

class MainScreenError extends MainScreenState {
  final String message;

  const MainScreenError({required this.message});

  @override
  List<Object?> get props => [message];
}
