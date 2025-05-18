import 'package:aggar/features/main_screen/admin/model/report_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {}

class UserByIdLoaded extends UserState {
  final ReportModel report;

  const UserByIdLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class UserUpdateStatus extends UserState {}

class UserTotalsLoaded extends UserState {
  final Map<String, int> totalReportsByType;

  const UserTotalsLoaded({required this.totalReportsByType});

  @override
  List<Object?> get props => [totalReportsByType];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
