import 'dart:async';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aggar/core/services/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;
  final FlutterSecureStorage _secureStorage;
  final TokenRefreshCubit _tokenRefreshCubit;
  final Connectivity _connectivity = Connectivity();

  List<Notification> _notifications = [];
  int _unreadCount = 0;
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _unreadCountSubscription;
  StreamSubscription? _tokenRefreshSubscription;
  StreamSubscription? _networkConnectivitySubscription;
  bool _isInitialized = false;
  Timer? _reconnectionTimer;
  bool _isReconnecting = false;
  bool _shouldBeConnected = false;

  NotificationCubit({
    required TokenRefreshCubit tokenRefreshCubit,
    NotificationService? notificationService,
    FlutterSecureStorage? secureStorage,
  })  : _tokenRefreshCubit = tokenRefreshCubit,
        _notificationService = notificationService ??
            NotificationService(
              apiConsumer: DioConsumer(dio: Dio()),
            ),
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        super(NotificationInitial()) {
    _setupTokenRefreshCubit();
    _setupSubscriptions();
    _setupNetworkConnectivity();
  }

  void _setupTokenRefreshCubit() {
    _notificationService.setTokenRefreshCubit(_tokenRefreshCubit);
    _tokenRefreshSubscription = _tokenRefreshCubit.stream.listen((state) {
      if (state is TokenRefreshFailure) {
        _notificationService.disconnect();
        emit(const NotificationError(
            'Authentication expired. Please login again.',
            isRecoverable: false));
      } else if (state is TokenRefreshSuccess) {
        if (_isInitialized &&
            !_notificationService.isConnected &&
            _shouldBeConnected) {
          reconnect();
        }
      }
    });
  }

  void _setupNetworkConnectivity() {
    _networkConnectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none &&
          _isInitialized &&
          _shouldBeConnected &&
          !_notificationService.isConnected) {
        // Short delay before attempting reconnect to allow network to stabilize
        await Future.delayed(const Duration(seconds: 1));
        reconnect();
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

      if (state is NotificationsLoaded) {
        emit((state as NotificationsLoaded).copyWith(
            notifications: List.from(_notifications),
            unreadCount: _unreadCount));
      } else {
        emit(NotificationReceived(
            notification: notification, unreadCount: _unreadCount));
        emit(NotificationsLoaded(
            notifications: List.from(_notifications),
            unreadCount: _unreadCount));
      }
    }, onError: (error) {
      emit(NotificationError('Failed to receive notification: $error'));
    });

    _connectionSubscription =
        _notificationService.onConnectionChange.listen((isConnected) {
      String? errorMessage;
      if (!isConnected && _shouldBeConnected) {
        errorMessage = 'Connection lost. Attempting to reconnect...';
      }
      emit(NotificationConnectionState(isConnected,
          connectionErrorMessage: errorMessage));

      if (isConnected) {
        _isReconnecting = false;
        _reconnectionTimer?.cancel();
        _shouldBeConnected = true;

        if (state is! NotificationsLoaded) {
          fetchNotifications();
        }
      } else if (_isInitialized && !_isReconnecting && _shouldBeConnected) {
        reconnect();
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
        emit(const NotificationError('User ID not found. Please login again.',
            isRecoverable: false));
        return;
      }

      final accessToken = await _tokenRefreshCubit.getAccessToken();
      if (accessToken == null) {
        emit(const NotificationError(
            'Authentication token expired. Please login again.',
            isRecoverable: false));
        return;
      }
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(const NotificationError(
            'No internet connection. Please check your network settings.',
            isRecoverable: true));
        return;
      }

      // Set this flag to indicate we should try to maintain connection
      _shouldBeConnected = true;

      await _notificationService.initialize(userId: userId);
      _isInitialized = true;
      await fetchNotifications();
    } catch (e) {
      // Detect specific WebSocket errors
      final errorMessage = e.toString();
      if (errorMessage.contains('WebSocketChannelException') ||
          errorMessage.contains('WebSocketException')) {
        emit(NotificationError('Failed to connect to notification server: $e',
            isRecoverable: true));
      } else {
        emit(NotificationError('Failed to initialize notifications: $e'));
      }

      if (!_notificationService.isConnected && _shouldBeConnected) {
        reconnect();
      }
    }
  }

  Future<void> fetchNotifications() async {
    final bool isRefresh = state is NotificationsLoaded;
    if (!isRefresh) {
      emit(NotificationLoading());
    }

    try {
      if (!_notificationService.isConnected) {
        await initialize();
      }

      final notifications = await _notificationService.getNotifications();
      final unreadCount =
          await _notificationService.getUnreadNotificationCount();
      _notifications = notifications;
      _unreadCount = unreadCount;

      emit(NotificationsLoaded(
        notifications: _notifications,
        unreadCount: _unreadCount,
      ));
    } catch (e) {
      emit(const NotificationsLoaded(
        notifications: [],
        unreadCount: 0,
      ));
      if (!_notificationService.isConnected && _shouldBeConnected) {
        reconnect();
      }
    }
  }

  Future<void> markAsRead(int notificationId) async {
    // Store previous state to revert to on failure
    final previousState = state;

    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        if (!_notifications[index].isRead) {
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

          if (_unreadCount > 0) _unreadCount--;

          emit(NotificationMarkedAsRead(
            notificationId: notificationId,
            unreadCount: _unreadCount,
          ));

          if (previousState is NotificationsLoaded) {
            emit(NotificationsLoaded(
              notifications: List.from(_notifications),
              unreadCount: _unreadCount,
            ));
          }
        }
      }
      await _tokenRefreshCubit.ensureValidToken();
      final success =
          await _notificationService.markNotificationAsRead(notificationId);

      if (!success) {
        emit(previousState);
        fetchNotifications();
      }

      _unreadCount = await _notificationService.getUnreadNotificationCount();

      if (state is NotificationsLoaded) {
        emit(
            (state as NotificationsLoaded).copyWith(unreadCount: _unreadCount));
      }
    } catch (e) {
      if (state is! NotificationsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> markAllAsRead() async {
    final previousState = state;

    try {
      List<Notification> updatedNotifications =
          _notifications.map((notification) {
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

      _notifications = updatedNotifications;
      _unreadCount = 0;

      emit(const AllNotificationsMarkedAsRead());
      emit(NotificationsLoaded(
        notifications: List.from(_notifications),
        unreadCount: 0,
      ));
      await _tokenRefreshCubit.ensureValidToken();
      final success = await _notificationService.markAllNotificationsAsRead();

      if (!success) {
        emit(previousState);
        fetchNotifications();
      }
    } catch (e) {
      if (state is! NotificationsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> reconnect() async {
    _isReconnecting = true;

    try {
      final token = await _tokenRefreshCubit.getAccessToken();
      if (token == null) {
        emit(const NotificationError(
            'Authentication expired. Please login again.',
            isRecoverable: false));
        _isReconnecting = false;
        return;
      }

      if (_notificationService.isConnected) {
        await _notificationService.disconnect();
      }

      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(const NotificationError(
            'No internet connection. Please check your network settings.',
            isRecoverable: true));
        _isReconnecting = false;
        return;
      }

      _shouldBeConnected = true;
      await initialize();
      _isReconnecting = false;
    } catch (e) {
      _isReconnecting = false;
      if (state is! NotificationsLoaded) {
        emit(NotificationsLoaded(
          notifications: _notifications,
          unreadCount: _unreadCount,
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _shouldBeConnected = false;
    _notificationSubscription?.cancel();
    _connectionSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    _networkConnectivitySubscription?.cancel();
    _reconnectionTimer?.cancel();
    _notificationService.dispose();
    return super.close();
  }
}
