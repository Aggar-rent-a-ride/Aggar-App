import 'package:equatable/equatable.dart';

abstract class ReportCreationState extends Equatable {
  const ReportCreationState();

  @override
  List<Object?> get props => [];
}

class ReportCreationInitial extends ReportCreationState {}

class ReportLoading extends ReportCreationState {}

class ReportsSuccess extends ReportCreationState {
  final String message;

  const ReportsSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReportError extends ReportCreationState {
  final String message;

  const ReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
