import 'dart:async';
import 'dart:convert';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:dio/dio.dart';

class Notification {
  final int id;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String? senderName;
  final String? senderAvatar;
  final Map<String, dynamic>? additionalData;

  Notification({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isRead,
    this.senderName,
    this.senderAvatar,
    this.additionalData,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    T? getValue<T>(String key, {T? defaultValue}) {
      return json[key] ??
          json[key.toLowerCase()] ??
          json[key.toUpperCase()] ??
          defaultValue;
    }

    return Notification(
      id: getValue<int>('id', defaultValue: 0) ?? 0,
      senderId: getValue<int>('senderId', defaultValue: 0) ?? 0,
      content: getValue<String>('content', defaultValue: '') ?? '',
      createdAt: getValue<String>('sentAt') != null
          ? DateTime.parse(getValue<String>('sentAt')!)
          : DateTime.now(),
      isRead: getValue<bool>('isSeen', defaultValue: false) ?? false,
      senderName: getValue<String>('senderName'),
      senderAvatar: getValue<String>('senderAvatar'),
      additionalData: {
        'targetType': getValue<String>('targetType'),
        'targetId': _extractTargetId(json),
      },
    );
  }

  static dynamic _extractTargetId(Map<String, dynamic> json) {
    // Helper function to get value with fallback for different case formats
    T? getValue<T>(String key) {
      return json[key] ?? json[key.toLowerCase()] ?? json[key.toUpperCase()];
    }

    final targetType = getValue<String>('targetType');
    if (targetType == null) return null;

    switch (targetType) {
      case 'Message':
        return getValue<int>('targetMessageId');
      case 'CustomerReview':
        return getValue<int>('targetCustomerReviewId');
      case 'RenterReview':
        return getValue<int>('targetRenterReviewId');
      case 'Booking':
        return getValue<int>('targetBookingId');
      case 'Rental':
        return getValue<int>('targetRentalId');
      default:
        return null;
    }
  }
}

class NotificationService {
  static final NotificationService _instance =
      NotificationService._internal(DioConsumer(dio: Dio()));
  factory NotificationService() => _instance;
  NotificationService._internal(this._dioConsumer);

  final DioConsumer _dioConsumer;

  HubConnection? _hubConnection;
  TokenRefreshCubit? _tokenRefreshCubit;
  bool _isConnected = false;
  int? _userId;

  final _notificationController = StreamController<Notification>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  final _unreadCountController = StreamController<int>.broadcast();

  Stream<Notification> get onNotificationReceived =>
      _notificationController.stream;
  Stream<bool> get onConnectionChange => _connectionController.stream;
  Stream<int> get onUnreadCountChange => _unreadCountController.stream;
  bool get isConnected => _isConnected;
  int get currentUserId => _userId ?? 0;
  void setTokenRefreshCubit(TokenRefreshCubit cubit) {
    _tokenRefreshCubit = cubit;
  }

  Future<void> initialize({required int userId}) async {
    _userId = userId;
    await _connectToNotificationHub();
  }

  Future<void> _connectToNotificationHub() async {
    if (_tokenRefreshCubit == null) {
      throw Exception('TokenRefreshCubit must be set before connecting');
    }

    final token = await _tokenRefreshCubit!.getAccessToken();
    if (token == null) {
      throw Exception('Failed to get access token');
    }

    try {
      // Close existing connection if any
      await disconnect();

      _hubConnection = HubConnectionBuilder()
          .withUrl(
              '${EndPoint.baseUrl}${EndPoint.notificationHub}?access_token=$token')
          .withAutomaticReconnect(
        retryDelays: [2000, 5000, 10000, 20000, 30000],
      ).build();

      _registerEventHandlers();

      await _hubConnection!.start();

      if (_hubConnection?.connectionId == null) {
        throw Exception('Failed to obtain SignalR connection ID');
      }

      _isConnected = true;
      _connectionController.add(true);

      print(
          'Notification Hub connection established successfully with ID: ${_hubConnection?.connectionId}');
    } catch (e) {
      _isConnected = false;
      _connectionController.add(false);
      print('Error establishing Notification Hub connection: $e');
      throw Exception('Failed to connect to notification hub: $e');
    }
  }

  void _registerEventHandlers() {
    _hubConnection!.on('ReceiveNotification', _handleReceiveNotification);
    _hubConnection!.on('UnreadCountUpdate', _handleUnreadCountUpdate);

    _hubConnection!.onreconnecting(({error}) {
      _isConnected = false;
      _connectionController.add(false);
      print('Notification Hub reconnecting: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _isConnected = true;
      _connectionController.add(true);
      print('Notification Hub reconnected with ID: $connectionId');
    });

    _hubConnection!.onclose(({error}) {
      _isConnected = false;
      _connectionController.add(false);
      print('Notification Hub connection closed: $error');
    });
  }

  void _handleReceiveNotification(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      String responseStr = parameters[0].toString();
      print('Received notification: $responseStr');

      // Handle possible format inconsistencies
      responseStr = responseStr.replaceAllMapped(
        RegExp(r'(\w+):'),
        (match) => '"${match.group(1)}":',
      );
      responseStr = responseStr.replaceAllMapped(
        RegExp(r':\s*([^",\{\}\[\]\s][^,\{\}\[\]]*[^",\{\}\[\]\s])'),
        (match) => ': "${match.group(1)}"',
      );

      final Map<String, dynamic> responseData = jsonDecode(responseStr);
      print('Parsed notification data: $responseData');

      // Handle different response formats
      Map<String, dynamic> notificationData;
      if (responseData.containsKey('data')) {
        notificationData = responseData['data'];
      } else {
        notificationData = responseData;
      }

      final notification = Notification.fromJson(notificationData);
      _notificationController.add(notification);
    } catch (e) {
      print('Error handling received notification: $e');
      _notificationController.addError('Failed to process notification: $e');
    }
  }

  void _handleUnreadCountUpdate(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final count = int.tryParse(parameters[0].toString()) ?? 0;
      _unreadCountController.add(count);
    } catch (e) {
      print('Error handling unread count update: $e');
    }
  }

  Future<void> _invokeHubMethod(
      String methodName, Map<String, dynamic> args) async {
    if (!_isConnected || _hubConnection == null) {
      print('Cannot invoke method: Hub not connected');
      throw Exception('Notification Hub not connected');
    }

    try {
      await _hubConnection!.invoke(methodName, args: [args]);
      print('Hub method $methodName invoked successfully');
    } catch (e) {
      print('Error invoking hub method $methodName: $e');
      throw Exception('Failed to invoke hub method $methodName: $e');
    }
  }

  Future<List<Notification>> getNotifications(
      {int page = 1, int pageSize = 20}) async {
    if (_tokenRefreshCubit == null) {
      throw Exception(
          'TokenRefreshCubit must be set before fetching notifications');
    }

    final token = await _tokenRefreshCubit!.getAccessToken();
    if (token == null) {
      throw Exception('Failed to get access token');
    }

    try {
      final response = await _dioConsumer.get(
        '/api/notification',
        queryParameters: {'pageNo': page, 'pageSize': pageSize},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      List<dynamic> notificationData = [];
      if (response is Map<String, dynamic>) {
        final data = response['data'];
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          notificationData = data['data'] as List<dynamic>;
        }
      }

      // Convert to ntification objects
      final notifications = notificationData.map((json) {
        if (json is Map<String, dynamic>) {
          return Notification.fromJson(json);
        } else {
          throw Exception('Invalid notification data format');
        }
      }).toList();

      print('Parsed ${notifications.length} notifications');
      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      if (e is Exception) {
        return [];
      }
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<int> getUnreadNotificationCount() async {
    if (_tokenRefreshCubit == null) {
      throw Exception(
          'TokenRefreshCubit must be set before fetching unread count');
    }

    final token = await _tokenRefreshCubit!.getAccessToken();
    if (token == null) {
      throw Exception('Failed to get access token');
    }

    try {
      final notifications = await getNotifications();
      return notifications.where((n) => !n.isRead).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    if (_tokenRefreshCubit == null) {
      throw Exception(
          'TokenRefreshCubit must be set before marking notifications as read');
    }

    final token = await _tokenRefreshCubit!.getAccessToken();
    if (token == null) {
      throw Exception('Failed to get access token');
    }

    try {
      await _dioConsumer.put(
        '/api/notification/ack',
        data: [notificationId],
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markAllNotificationsAsRead() async {
    if (_tokenRefreshCubit == null) {
      throw Exception(
          'TokenRefreshCubit must be set before marking all notifications as read');
    }

    final token = await _tokenRefreshCubit!.getAccessToken();
    if (token == null) {
      throw Exception('Failed to get access token');
    }

    final notifications = await getNotifications(page: 1, pageSize: 100);
    final unreadIds = notifications
        .where((notification) => !notification.isRead)
        .map((notification) => notification.id)
        .toList();

    if (unreadIds.isEmpty) {
      return true;
    }

    try {
      await _dioConsumer.put(
        '/api/notification/ack',
        data: unreadIds,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendNotification({
    required String clientMessageId,
    required int receiverId,
    required String content,
  }) async {
    if (_isConnected && _hubConnection != null) {
      await _invokeHubMethod('SendNotification', {
        'clientMessageId': clientMessageId,
        'receiverId': receiverId,
        'content': content,
      });
    } else {
      if (_tokenRefreshCubit == null) {
        throw Exception(
            'TokenRefreshCubit must be set before sending notification');
      }

      final token = await _tokenRefreshCubit!.getAccessToken();
      if (token == null) {
        throw Exception('Failed to get access token');
      }

      final data = {
        'clientMessageId': clientMessageId,
        'receiverId': receiverId,
        'content': content,
      };

      await _dioConsumer.post(
        '/api/notification',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    }
  }

  Future<void> reconnect() async {
    if (_userId == null) {
      throw Exception('Must initialize with userId before reconnecting');
    }
    await _connectToNotificationHub();
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _isConnected = false;
      _connectionController.add(false);
      print('Notification Hub connection closed');
    }
  }

  String? get connectionId => _hubConnection?.connectionId;

  void dispose() {
    disconnect();
    _notificationController.close();
    _connectionController.close();
    _unreadCountController.close();
  }
}
