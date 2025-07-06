import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static bool _permissionsGranted = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: false, // We'll request manually
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);

    final initialized = await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print('Local notification tapped: ${details.payload}');
        _handleNotificationTap(details);
      },
    );

    if (initialized == true) {
      _isInitialized = true;
      print('Local notifications initialized successfully');

      // Create notification channels for Android
      await _createNotificationChannels();
    } else {
      print('Failed to initialize local notifications');
    }
  }

  static Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel signalrChannel =
        AndroidNotificationChannel(
      'signalr_notifications',
      'App Notifications',
      description: 'Notifications from the app',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    const AndroidNotificationChannel defaultChannel =
        AndroidNotificationChannel(
      'default_channel',
      'Default',
      description: 'Default notification channel',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(signalrChannel);
      await androidImplementation.createNotificationChannel(defaultChannel);
      print('Notification channels created');
    }
  }

  static Future<bool> requestPermissions() async {
    if (_permissionsGranted) return true;

    try {
      // Android 13+
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        print('Android notification permissions: $granted');
        if (granted != null && !granted) return false;
      }

      // iOS
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _plugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        print('iOS notification permissions: $granted');
        if (granted != null && !granted) return false;
      }
    } catch (e) {
      print('Error requesting notification permissions: $e');
      return false;
    }
    _permissionsGranted = true;
    return true;
  }

  static Future<void> show(
    String title,
    String body, {
    String? payload,
    String channelId = 'default_channel',
    String channelName = 'Default',
    String channelDescription = 'Default notification channel',
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) async {
    if (!_isInitialized) {
      print('Local notifications not initialized');
      await initialize();
    }

    if (!_permissionsGranted) {
      print('Notification permissions not granted');
      final granted = await requestPermissions();
      if (!granted) {
        print('Cannot show notification: permissions denied');
        return;
      }
    }

    try {
      final android = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        ticker: 'New notification',
        autoCancel: true,
        ongoing: false,
      );

      const iOS = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      final details = NotificationDetails(android: android, iOS: iOS);

      // Use a unique ID for each notification
      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _plugin.show(
        notificationId,
        title,
        body,
        details,
        payload: payload,
      );

      print('Local notification shown: $title - $body');
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  // Show notification specifically for SignalR notifications
  static Future<void> showSignalRNotification({
    required String title,
    required String body,
    String? senderName,
    String? notificationType,
    int? notificationId,
    Map<String, dynamic>? additionalData,
  }) async {
    // Create payload with notification data
    final payload = {
      'id': notificationId,
      'type': notificationType,
      'senderName': senderName,
      'additionalData': additionalData,
    };

    await show(
      title,
      body,
      payload: payload.toString(),
      channelId: 'signalr_notifications',
      channelName: 'App Notifications',
      channelDescription: 'Notifications from the app',
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  // Test notification method
  static Future<void> showTestNotification() async {
    await show(
      'Test Notification',
      'This is a test notification to verify the setup',
      payload: 'test_payload',
    );
  }

  // Handle notification tap
  static void _handleNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      print('Notification tapped with payload: ${details.payload}');
      // Add your navigation logic here
      // You can use a global navigator key or event bus to handle navigation
    }
  }

  // Cancel all notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // Cancel specific notification
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (!_isInitialized) return false;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    return _permissionsGranted;
  }

  // Get notification permission status
  static Future<PermissionStatus> getNotificationPermissionStatus() async {
    return await Permission.notification.status;
  }
}
