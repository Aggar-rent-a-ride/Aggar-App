import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final Map<String, int> totalReportsByType;

  const StatisticsLoaded({
    required this.totalReportsByType,
  });

  @override
  List<Object?> get props => [totalReportsByType];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError({required this.message});

  @override
  List<Object?> get props => [message];
}
