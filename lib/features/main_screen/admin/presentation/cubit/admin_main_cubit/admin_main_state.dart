import 'package:equatable/equatable.dart';

abstract class AdminMainState extends Equatable {
  const AdminMainState();

  @override
  List<Object?> get props => [];
}

class AdminMainInitial extends AdminMainState {}

class AdminMainLoading extends AdminMainState {}

class AdminMainConnected extends AdminMainState {
  final String accessToken;
  final bool isStatisticsLoaded;
  final bool isReportsLoaded;
  final bool isUserStatisticsLoaded;
  final bool isSignalRConnected;

  const AdminMainConnected({
    required this.accessToken,
    required this.isStatisticsLoaded,
    required this.isReportsLoaded,
    required this.isUserStatisticsLoaded,
    this.isSignalRConnected = false,
  });

  @override
  List<Object?> get props => [
        accessToken,
        isStatisticsLoaded,
        isReportsLoaded,
        isUserStatisticsLoaded,
        isSignalRConnected,
      ];
}

class AdminMainDisconnected extends AdminMainState {}

class AdminMainAuthError extends AdminMainState {
  final String message;

  const AdminMainAuthError(this.message);

  @override
  List<Object?> get props => [message];
}