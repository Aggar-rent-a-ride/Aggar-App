import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationEnabled extends NotificationState {
  final bool isEnabled;
  NotificationEnabled(this.isEnabled);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

enum NotificationType {
  chatMessage,
  fileReceived,
  userOnline,
  systemAlert,
  reminder,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final Map<String, dynamic>? payload;
  final DateTime timestamp;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.name,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        type: NotificationType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => NotificationType.systemAlert,
        ),
        payload: json['payload'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class NotificationCubit extends Cubit<NotificationState> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  bool _isInitialized = false;
  final _notificationTapController = StreamController<AppNotification>.broadcast();
  final _notificationReceivedController = StreamController<AppNotification>.broadcast();
  
  Stream<AppNotification> get onNotificationTapped => _notificationTapController.stream;
  Stream<AppNotification> get onNotificationReceived => _notificationReceivedController.stream;

  NotificationCubit() : super(NotificationInitial());

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Android settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      await _requestPermissions();
      
      _isInitialized = true;
      final isEnabled = await areNotificationsEnabled();
      emit(NotificationEnabled(isEnabled));
    } catch (e) {
      emit(NotificationError('Failed to initialize notifications: $e'));
    }
  }

  // Request permissions
  Future<void> _requestPermissions() async {
    // Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // iOS
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final notification = AppNotification.fromJson(data);
        _notificationTapController.add(notification);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  // Show notification
  Future<void> showNotification(AppNotification notification) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final notificationDetails = _getNotificationDetails(notification.type);
      
      await _flutterLocalNotificationsPlugin.show(
        notification.id.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode(notification.toJson()),
      );

      _notificationReceivedController.add(notification);
    } catch (e) {
      emit(NotificationError('Failed to show notification: $e'));
    }
  }

  // Get notification details based on type
  NotificationDetails _getNotificationDetails(NotificationType type) {
    switch (type) {
      case NotificationType.chatMessage:
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'chat_messages',
            'Chat Messages',
            channelDescription: 'Notifications for chat messages',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFF2196F3),
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );

      case NotificationType.fileReceived:
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'file_transfers',
            'File Transfers',
            channelDescription: 'Notifications for file transfers',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFF4CAF50),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );

      case NotificationType.userOnline:
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'user_status',
            'User Status',
            channelDescription: 'Notifications for user status changes',
            importance: Importance.low,
            priority: Priority.low,
            icon: '@mipmap/ic_launcher',
            showWhen: false,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: false,
            presentBadge: true,
            presentSound: false,
          ),
        );

      case NotificationType.systemAlert:
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'system_alerts',
            'System Alerts',
            channelDescription: 'Important system notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFFF44336),
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.critical,
          ),
        );

      case NotificationType.reminder:
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            'Reminders',
            channelDescription: 'Reminder notifications',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFFFF9800),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
    }
  }

  // Convenience methods for different notification types
  Future<void> showChatMessage({
    required String senderId,
    required String senderName,
    required String message,
    String? messageId,
    Map<String, dynamic>? additionalData,
  }) async {
    final notification = AppNotification(
      id: messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: senderName,
      body: message,
      type: NotificationType.chatMessage,
      payload: {
        'senderId': senderId,
        'senderName': senderName,
        'messageId': messageId,
        ...?additionalData,
      },
    );

    await showNotification(notification);
  }

  Future<void> showFileReceived({
    required String senderId,
    required String senderName,
    required String fileName,
    Map<String, dynamic>? additionalData,
  }) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: senderName,
      body: 'Sent a file: $fileName',
      type: NotificationType.fileReceived,
      payload: {
        'senderId': senderId,
        'senderName': senderName,
        'fileName': fileName,
        ...?additionalData,
      },
    );

    await showNotification(notification);
  }

  Future<void> showUserOnline({
    required String userId,
    required String userName,
  }) async {
    final notification = AppNotification(
      id: 'user_online_$userId',
      title: 'User Online',
      body: '$userName is now online',
      type: NotificationType.userOnline,
      payload: {
        'userId': userId,
        'userName': userName,
        'status': 'online',
      },
    );

    await showNotification(notification);
  }

  Future<void> showSystemAlert({
    required String title,
    required String message,
    Map<String, dynamic>? additionalData,
  }) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: message,
      type: NotificationType.systemAlert,
      payload: additionalData,
    );

    await showNotification(notification);
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (!_isInitialized) return false;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    return true; // Assume enabled for iOS
  }

  // Open notification settings
  Future<void> openNotificationSettings() async {
    await AppSettings.openAppSettings();
  }

  // Cancel specific notification
  Future<void> cancelNotification(String notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId.hashCode);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Schedule notification (for reminders, etc.)
  Future<void> scheduleNotification(
    AppNotification notification,
    DateTime scheduledDate,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notification.id.hashCode,
        notification.title,
        notification.body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _getNotificationDetails(notification.type),
        payload: jsonEncode(notification.toJson()),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      emit(NotificationError('Failed to schedule notification: $e'));
    }
  }

  @override
  Future<void> close() {
    _notificationTapController.close();
    _notificationReceivedController.close();
    return super.close();
  }
}