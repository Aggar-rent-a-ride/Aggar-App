import 'package:aggar/core/services/notification_service.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];

  NotificationsLoaded copyWith({
    List<Notification>? notifications,
    int? unreadCount,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationReceived extends NotificationState {
  final Notification notification;
  final int unreadCount;

  const NotificationReceived({
    required this.notification,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notification, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationConnectionState extends NotificationState {
  final bool isConnected;

  const NotificationConnectionState(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class NotificationMarkedAsRead extends NotificationState {
  final int notificationId;
  final int unreadCount;

  const NotificationMarkedAsRead({
    required this.notificationId,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notificationId, unreadCount];
}

class AllNotificationsMarkedAsRead extends NotificationState {
  const AllNotificationsMarkedAsRead();
}
