import 'package:aggar/features/main_screen/admin/model/list_user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserNoSearch extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final ListUserModel users;

  const UserLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

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
