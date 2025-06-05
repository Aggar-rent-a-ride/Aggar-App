import 'package:aggar/features/main_screen/admin/model/list_report_model.dart';
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

class ReportsLoadingMore extends ReportState {
  final ListReportModel reports;

  const ReportsLoadingMore({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class ReportsLoading extends ReportState {}

class ReportUpdateStatus extends ReportState {}

class ReportError extends ReportState {
  final String message;

  const ReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

class FilterToggleVisibility extends ReportState {
  final bool isVisible;

  const FilterToggleVisibility(this.isVisible);
}

class FilterTypeSelected extends ReportState {
  final String? type;

  const FilterTypeSelected(this.type);
}

class FilterStatusSelected extends ReportState {
  final String? status;

  const FilterStatusSelected(this.status);
}

class FilterDateSelected extends ReportState {
  final String? date;

  const FilterDateSelected(this.date);
}

class FilterSortingDirectionSelected extends ReportState {
  final String? sortingDirection;

  const FilterSortingDirectionSelected(this.sortingDirection);
}

class FilterReset extends ReportState {}
