import 'package:equatable/equatable.dart';

abstract class UserStatisticsState extends Equatable {
  const UserStatisticsState();

  @override
  List<Object?> get props => [];
}

class UserStatisticsInitial extends UserStatisticsState {}

class UserStatisticsLoading extends UserStatisticsState {}

class UserStatisticsError extends UserStatisticsState {
  final String message;

  const UserStatisticsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserStatisticsUserLoading extends UserStatisticsState {}

class UserStatisticsUserTotalsLoaded extends UserStatisticsState {
  final Map<String, int> totalUsersByRole;

  const UserStatisticsUserTotalsLoaded({required this.totalUsersByRole});

  @override
  List<Object?> get props => [totalUsersByRole];
}
