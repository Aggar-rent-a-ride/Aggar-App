import 'package:aggar/features/main_screen/admin/model/list_report_model.dart';
import 'package:aggar/features/main_screen/admin/model/report_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportsLoaded extends ReportState {
  final ListReportModel reports;

  const ReportsLoaded({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class ReportsLoading extends ReportState {}

class ReportDataLoaded extends ReportState {
  final Map<String, int> totalReportsByType;

  const ReportDataLoaded({
    required this.totalReportsByType,
  });

  @override
  List<Object?> get props => [totalReportsByType];
}

class ReportByIdLoaded extends ReportState {
  final ReportModel report;

  const ReportByIdLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class ReportUpdateStatus extends ReportState {}

class ReportError extends ReportState {
  final String message;

  const ReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
