import 'package:aggar/features/main_screen/admin/model/report_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportByIdState extends Equatable {
  const ReportByIdState();

  @override
  List<Object?> get props => [];
}

class ReportByIdInitial extends ReportByIdState {}

class ReportsByIdLoading extends ReportByIdState {}

class ReportByIdLoaded extends ReportByIdState {
  final ReportModel report;

  const ReportByIdLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class ReportByIdError extends ReportByIdState {
  final String message;

  const ReportByIdError({required this.message});

  @override
  List<Object?> get props => [message];
}
