import 'package:aggar/features/main_screen/admin/model/list_user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserNoSearch extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final ListUserModel users;

  const UserLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class UsersLoadingMore extends UserState {
  final ListUserModel users;

  const UsersLoadingMore({required this.users});

  @override
  List<Object?> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
