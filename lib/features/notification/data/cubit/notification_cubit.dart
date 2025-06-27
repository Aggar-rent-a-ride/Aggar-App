import 'dart:async';
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
  int _reconnectionAttempt = 0;
  final int _maxReconnectionAttempts = 5;

  NotificationCubit({
    required TokenRefreshCubit tokenRefreshCubit,
    NotificationService? notificationService,
    FlutterSecureStorage? secureStorage,
  })  : _tokenRefreshCubit = tokenRefreshCubit,
        _notificationService = notificationService ?? NotificationService(),
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
        await Future.delayed(const Duration(seconds: 1));
        _reconnectionAttempt = 0;
        reconnect();
      }
    });
  }

  void _setupSubscriptions() {
    _notificationSubscription?.cancel();
    _connectionSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    print('Setting up notification subscription');

    _notificationSubscription =
        _notificationService.onNotificationReceived.listen((notification) {
      print('Notification received: ${notification.id}');
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
      print('Notification error: $error');
      emit(NotificationError('Failed to receive notification: $error'));
    });

    _connectionSubscription =
        _notificationService.onConnectionChange.listen((isConnected) {
      print('Connection status changed: $isConnected');
      String? errorMessage;
      if (!isConnected && _shouldBeConnected) {
        errorMessage = 'Connection lost. Attempting to reconnect...';
      }
      emit(NotificationConnectionState(isConnected,
          connectionErrorMessage: errorMessage));

      if (isConnected) {
        _isReconnecting = false;
        _reconnectionTimer?.cancel();
        _reconnectionAttempt = 0;
        _shouldBeConnected = true;

        if (state is! NotificationsLoaded) {
          fetchNotifications();
        }
      } else if (_isInitialized && !_isReconnecting && _shouldBeConnected) {
        _scheduleReconnect();
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

    print('Initializing notification service');
    emit(NotificationLoading());
    try {
      final userIdStr = await _secureStorage.read(key: 'userId');
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;

      print('User ID: $userId');
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

      _shouldBeConnected = true;
      _reconnectionAttempt = 0;

      print('Calling notification service initialize');
      await _notificationService.initialize(userId: userId);
      _isInitialized = true;
      print('Notification service initialized successfully');
      await fetchNotifications();
    } catch (e) {
      print('Error initializing notification service: $e');
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
        _scheduleReconnect();
      }
    }
  }

  Future<void> fetchNotifications() async {
    final bool isRefresh = state is NotificationsLoaded;
    if (!isRefresh) {
      emit(NotificationLoading());
    }

    try {
      print('Fetching notifications');
      if (!_notificationService.isConnected) {
        print('Service not connected, initializing first');
        await initialize();
      }

      final notifications = await _notificationService.getNotifications();
      final unreadCount =
          await _notificationService.getUnreadNotificationCount();
      print(
          'Fetched ${notifications.length} notifications, $unreadCount unread');
      _notifications = notifications;
      _unreadCount = unreadCount;

      emit(NotificationsLoaded(
        notifications: _notifications,
        unreadCount: _unreadCount,
      ));
    } catch (e) {
      print('Error fetching notifications: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          await _tokenRefreshCubit.refreshToken();
          if (_tokenRefreshCubit.state is TokenRefreshSuccess) {
            return fetchNotifications();
          } else {
            emit(const NotificationError(
                'Authentication expired. Please login again.',
                isRecoverable: false));
            return;
          }
        }
      }
      emit(NotificationsLoaded(
        notifications: _notifications,
        unreadCount: _unreadCount,
      ));
      if (!_notificationService.isConnected && _shouldBeConnected) {
        _scheduleReconnect();
      }
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final previousState = state;
    try {
      print('Marking notification $notificationId as read');
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

          emit(NotificationsLoaded(
            notifications: List.from(_notifications),
            unreadCount: _unreadCount,
          ));
        }
      }
      await _tokenRefreshCubit.ensureValidToken();
      final success =
          await _notificationService.markNotificationAsRead(notificationId);

      if (!success) {
        print('Failed to mark notification as read on server');
        emit(previousState);
        fetchNotifications();
      }

      _unreadCount = await _notificationService.getUnreadNotificationCount();

      if (state is NotificationsLoaded) {
        emit(
            (state as NotificationsLoaded).copyWith(unreadCount: _unreadCount));
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        await _tokenRefreshCubit.refreshToken();
        if (_tokenRefreshCubit.state is TokenRefreshSuccess) {
          return markAsRead(notificationId);
        }
      }
      if (state is! NotificationsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> markAllAsRead() async {
    final previousState = state;

    try {
      print('Marking all notifications as read');
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
        print('Failed to mark all notifications as read on server');
        emit(previousState);
        fetchNotifications();
      }
    } catch (e) {
      print('Error marking all notifications as read: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        await _tokenRefreshCubit.refreshToken();
        if (_tokenRefreshCubit.state is TokenRefreshSuccess) {
          return markAllAsRead();
        }
      }
      if (state is! NotificationsLoaded) {
        emit(previousState);
      }
    }
  }

  void _scheduleReconnect() {
    if (_isReconnecting || !_shouldBeConnected) return;

    _isReconnecting = true;
    _reconnectionAttempt++;

    print('Scheduling reconnection attempt $_reconnectionAttempt');
    if (_reconnectionAttempt > _maxReconnectionAttempts) {
      emit(const NotificationError(
          'Failed to reconnect after multiple attempts. Please try again later.',
          isRecoverable: true));
      _isReconnecting = false;
      return;
    }
    const baseDelay = 1000;
    const maxDelay = 30000;
    final exponentialDelay = baseDelay * (1 << (_reconnectionAttempt - 1));
    final delay = Duration(
        milliseconds:
            (exponentialDelay < maxDelay ? exponentialDelay : maxDelay) +
                (DateTime.now().millisecondsSinceEpoch % 1000)); // Add jitter

    emit(ConnectionRetrying(
      attemptNumber: _reconnectionAttempt,
      maxAttempts: _maxReconnectionAttempts,
      nextRetryIn: delay,
    ));
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(delay, () {
      reconnect();
    });
  }

  Future<void> reconnect() async {
    if (!_shouldBeConnected) {
      _isReconnecting = false;
      return;
    }

    try {
      print('Attempting to reconnect');
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
        _scheduleReconnect();
        return;
      }

      await initialize();
      _isReconnecting = false;
    } catch (e) {
      print('Error reconnecting: $e');
      _isReconnecting = false;
      _scheduleReconnect();
      if (state is! NotificationsLoaded && _notifications.isNotEmpty) {
        emit(NotificationsLoaded(
          notifications: _notifications,
          unreadCount: _unreadCount,
        ));
      }
    }
  }

  @override
  Future<void> close() {
    print('Closing notification cubit');
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
