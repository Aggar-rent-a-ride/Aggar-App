import 'dart:async';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aggar/core/services/notification_service.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService = NotificationService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TokenRefreshCubit _tokenRefreshCubit;

  List<Notification> _notifications = [];
  int _unreadCount = 0;
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _unreadCountSubscription;
  StreamSubscription? _tokenRefreshSubscription;
  bool _isInitialized = false;

  NotificationCubit({required TokenRefreshCubit tokenRefreshCubit})
      : _tokenRefreshCubit = tokenRefreshCubit,
        super(NotificationInitial()) {
    _setupTokenRefreshCubit();
    _setupSubscriptions();
  }

  void _setupTokenRefreshCubit() {
    _notificationService.setTokenRefreshCubit(_tokenRefreshCubit);
    _tokenRefreshSubscription = _tokenRefreshCubit.stream.listen((state) {
      if (state is TokenRefreshFailure) {
        _notificationService.disconnect();
        emit(const NotificationError(
            'Authentication expired. Please login again.'));
      } else if (state is TokenRefreshSuccess) {
        if (_isInitialized && !_notificationService.isConnected) {
          _notificationService.initialize(
              userId: _notificationService.currentUserId);
        }
      }
    });
  }

  void _setupSubscriptions() {
    _notificationSubscription?.cancel();
    _connectionSubscription?.cancel();
    _unreadCountSubscription?.cancel();

    _notificationSubscription =
        _notificationService.onNotificationReceived.listen((notification) {
      _notifications.insert(0, notification);
      _unreadCount++;
      emit(NotificationReceived(
          notification: notification, unreadCount: _unreadCount));
      emit(NotificationsLoaded(
          notifications: List.from(_notifications), unreadCount: _unreadCount));
    }, onError: (error) {
      emit(NotificationError('Failed to receive notification: $error'));
    });

    _connectionSubscription =
        _notificationService.onConnectionChange.listen((isConnected) {
      emit(NotificationConnectionState(isConnected));
      if (isConnected && state is! NotificationsLoaded) {
        fetchNotifications();
      }
    });

    _unreadCountSubscription =
        _notificationService.onUnreadCountChange.listen((count) {
      _unreadCount = count;
      if (state is NotificationsLoaded) {
        emit((state as NotificationsLoaded).copyWith(unreadCount: count));
      }
    });
  }

  Future<void> initialize() async {
    if (_isInitialized && _notificationService.isConnected) return;

    emit(NotificationLoading());
    try {
      final userIdStr = await _secureStorage.read(key: 'userId');
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;

      if (userId == null) {
        emit(const NotificationError('User ID not found. Please login again.'));
        return;
      }

      final accessToken = await _tokenRefreshCubit.getAccessToken();
      if (accessToken == null) {
        emit(const NotificationError(
            'Authentication token expired. Please login again.'));
        return;
      }

      await _notificationService.initialize(userId: userId);
      _isInitialized = true;
      await fetchNotifications();
    } catch (e) {
      emit(NotificationError('Failed to initialize notifications: $e'));
    }
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      if (!_notificationService.isConnected) {
        await initialize();
      }

      _notifications = await _notificationService.getNotifications();
      _unreadCount = await _notificationService.getUnreadNotificationCount();

      emit(NotificationsLoaded(
        notifications: _notifications,
        unreadCount: _unreadCount,
      ));
    } catch (e) {
      emit(NotificationError('Failed to fetch notifications: $e'));
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _tokenRefreshCubit.ensureValidToken();
      final success =
          await _notificationService.markNotificationAsRead(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final updatedNotification = Notification(
            id: _notifications[index].id,
            senderId: _notifications[index].senderId,
            content: _notifications[index].content,
            createdAt: _notifications[index].createdAt,
            isRead: true,
            senderName: _notifications[index].senderName,
            senderAvatar: _notifications[index].senderAvatar,
            additionalData: _notifications[index].additionalData,
          );

          _notifications[index] = updatedNotification;
          _unreadCount =
              await _notificationService.getUnreadNotificationCount();

          emit(NotificationMarkedAsRead(
            notificationId: notificationId,
            unreadCount: _unreadCount,
          ));

          emit(NotificationsLoaded(
            notifications: List.from(_notifications),
            unreadCount: _unreadCount,
          ));
        }
      }
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read: $e'));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _tokenRefreshCubit.ensureValidToken();
      final success = await _notificationService.markAllNotificationsAsRead();
      if (success) {
        _notifications = _notifications.map((notification) {
          return Notification(
            id: notification.id,
            senderId: notification.senderId,
            content: notification.content,
            createdAt: notification.createdAt,
            isRead: true,
            senderName: notification.senderName,
            senderAvatar: notification.senderAvatar,
            additionalData: notification.additionalData,
          );
        }).toList();

        _unreadCount = 0;

        emit(const AllNotificationsMarkedAsRead());
        emit(NotificationsLoaded(
          notifications: List.from(_notifications),
          unreadCount: 0,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark all notifications as read: $e'));
    }
  }

  Future<void> reconnect() async {
    try {
      final token = await _tokenRefreshCubit.getAccessToken();
      if (token == null) {
        emit(const NotificationError(
            'Authentication expired. Please login again.'));
        return;
      }
      if (_notificationService.isConnected) {
        await _notificationService.disconnect();
      }
      await initialize();
    } catch (e) {
      emit(NotificationError('Failed to reconnect: $e'));
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _connectionSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    _notificationService.dispose();
    return super.close();
  }
}
