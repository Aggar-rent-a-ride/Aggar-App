import 'dart:async';
import 'dart:convert';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:aggar/core/api/end_points.dart';

class Notification {
  final int id;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String? senderName;
  final String? senderAvatar;
  final String? additionalData;

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
    return Notification(
      id: json['id'] ?? 0,
      senderId: json['senderId'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      additionalData: json['additionalData'],
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  TokenRefreshCubit? _tokenRefreshCubit;

  HubConnection? _hubConnection;
  bool _isConnected = false;
  int _currentUserId = 0;

  final _notificationController = StreamController<Notification>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _unreadCountController = StreamController<int>.broadcast();

  Stream<Notification> get onNotificationReceived =>
      _notificationController.stream;
  Stream<bool> get onConnectionChange => _connectionStatusController.stream;
  Stream<int> get onUnreadCountChange => _unreadCountController.stream;

  bool get isConnected => _isConnected;
  int get currentUserId => _currentUserId;
  String? get connectionId => _hubConnection?.connectionId;

  void setTokenRefreshCubit(TokenRefreshCubit tokenRefreshCubit) {
    _tokenRefreshCubit = tokenRefreshCubit;
  }

  Future<void> initialize({int? userId}) async {
    if (_isConnected && _hubConnection?.connectionId != null) {
      print(
          'Notification SignalR connection already established with ID: ${_hubConnection?.connectionId}');
      return;
    }

    try {
      if (userId != null) {
        _currentUserId = userId;
      }

      // Get a valid access token using TokenRefreshCubit if available
      String? accessToken;
      if (_tokenRefreshCubit != null) {
        accessToken = await _tokenRefreshCubit!.getAccessToken();
      }

      // Fall back to secure storage if needed
      accessToken ??= await _secureStorage.read(key: 'accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Access token not found. Please login first.');
      }

      if (_hubConnection != null) {
        await _hubConnection!.stop();
        _hubConnection = null;
      }

      _hubConnection = HubConnectionBuilder()
          .withUrl(
              '${EndPoint.baseUrl}${EndPoint.notificationHub}?access_token=$accessToken')
          .withAutomaticReconnect(
              retryDelays: [2000, 5000, 10000, 20000, 30000]).build();

      _registerEventHandlers();

      await _hubConnection!.start();

      if (_hubConnection?.connectionId == null) {
        throw Exception('Failed to obtain Notification SignalR connection ID');
      }

      _isConnected = true;
      _connectionStatusController.add(true);

      // Fetch unread count after successful connection
      await getUnreadNotificationCount();

      print(
          'Notification SignalR connection established successfully with ID: ${_hubConnection?.connectionId}');
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('Error establishing Notification SignalR connection: $e');
      throw Exception('Failed to connect to notification server: $e');
    }
  }

  void _registerEventHandlers() {
    _hubConnection!.on('ReceiveNotification', _handleReceiveNotification);
    _hubConnection!.on('UpdateUnreadCount', _handleUnreadCountUpdate);

    _hubConnection!.onreconnecting(({error}) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('Notification SignalR reconnecting: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) async {
      // Get a fresh token when reconnecting
      String? accessToken;
      if (_tokenRefreshCubit != null) {
        accessToken = await _tokenRefreshCubit!.getAccessToken();
        if (accessToken == null) {
          print('Failed to get valid token when reconnecting');
          _isConnected = false;
          _connectionStatusController.add(false);
          return;
        }
      }

      _isConnected = true;
      _connectionStatusController.add(true);
      print('Notification SignalR reconnected with ID: $connectionId');
      getUnreadNotificationCount();
    });

    _hubConnection!.onclose(({error}) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('Notification SignalR connection closed: $error');
    });
  }

  Future<void> disconnect() async {
    if (!_isConnected || _hubConnection == null) return;

    try {
      await _hubConnection!.stop();
      _isConnected = false;
      _connectionStatusController.add(false);
      print('Notification SignalR connection closed');
    } catch (e) {
      print('Error closing Notification SignalR connection: $e');
    }
  }

  Future<T?> _invokeMethod<T>(
      String methodName, Map<String, dynamic> args) async {
    if (!_isConnected || _hubConnection == null) {
      print('Cannot invoke method: Notification SignalR not connected');

      // Try to get a fresh token and reconnect if token refresh cubit is available
      if (_tokenRefreshCubit != null) {
        try {
          final token = await _tokenRefreshCubit!.getAccessToken();
          if (token != null) {
            await initialize();
            // If reconnected successfully, proceed with the method invocation
            if (_isConnected && _hubConnection != null) {
              return _invokeMethodInternal<T>(methodName, args);
            }
          }
        } catch (e) {
          print('Failed to reconnect with fresh token: $e');
        }
      }

      throw Exception('Notification SignalR not connected');
    }

    return _invokeMethodInternal<T>(methodName, args);
  }

  Future<T?> _invokeMethodInternal<T>(
      String methodName, Map<String, dynamic> args) async {
    try {
      final result = await _hubConnection!.invoke(methodName, args: [args]);
      return _parseResponse<T>(result);
    } catch (e) {
      print('Error invoking method $methodName: $e');
      throw Exception('Failed to invoke method $methodName: $e');
    }
  }

  T? _parseResponse<T>(dynamic response) {
    if (response == null) return null;

    try {
      if (response is String) {
        final Map<String, dynamic> parsed = jsonDecode(response);
        if (parsed.containsKey('data')) {
          return parsed['data'] as T?;
        }
        return response as T?;
      }
      return response as T?;
    } catch (e) {
      print('Error parsing response: $e');
      return null;
    }
  }

  Future<List<Notification>> getNotifications() async {
    try {
      final result =
          await _invokeMethod<List<dynamic>>('GetNotificationsAsync', {});
      if (result == null) return [];

      return result
          .map((item) =>
              Notification.fromJson(item is String ? jsonDecode(item) : item))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final result =
          await _invokeMethod<dynamic>('GetUnreadNotificationCountAsync', {});

      int count = 0;
      if (result is int) {
        count = result;
      } else if (result is String) {
        count = int.tryParse(result) ?? 0;
      } else if (result is Map) {
        count = result['count'] ?? 0;
      }

      _unreadCountController.add(count);
      return count;
    } catch (e) {
      print('Error fetching unread notification count: $e');
      return 0;
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      await _invokeMethod(
          'MarkNotificationAsReadAsync', {'notificationId': notificationId});

      await getUnreadNotificationCount();
      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  Future<bool> markAllNotificationsAsRead() async {
    try {
      await _invokeMethod('MarkAllNotificationsAsReadAsync', {});
      _unreadCountController.add(0);
      return true;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  void _handleReceiveNotification(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final String responseStr = _normalizeJsonString(parameters[0].toString());
      print('Received notification: $responseStr');

      final Map<String, dynamic> responseData = jsonDecode(responseStr);

      if (_isErrorResponse(responseData)) {
        _notificationController
            .addError(responseData['message'] ?? 'Unknown error occurred');
        return;
      }

      final notificationData = _extractDataFromResponse(responseData);
      final notification = Notification.fromJson(notificationData);
      _notificationController.add(notification);

      // Update unread count when new notification arrives
      getUnreadNotificationCount();
    } catch (e) {
      print('Error handling received notification: $e');
      _notificationController.addError('Failed to process notification: $e');
    }
  }

  String _normalizeJsonString(String jsonStr) {
    // Fix keys without quotes
    jsonStr = jsonStr.replaceAllMapped(
      RegExp(r'(\w+):'),
      (match) => '"${match.group(1)}":',
    );

    // Fix values without quotes (except true/false/null/numbers)
    jsonStr = jsonStr.replaceAllMapped(
      RegExp(r':\s*([^",\{\}\[\]\s][^,\{\}\[\]]*[^",\{\}\[\]\s])'),
      (match) {
        final value = match.group(1);
        if (value == 'true' ||
            value == 'false' ||
            value == 'null' ||
            RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value!)) {
          return ': $value';
        }
        return ': "$value"';
      },
    );

    return jsonStr;
  }

  bool _isErrorResponse(Map<String, dynamic> response) {
    return response['statusCode'] != null && response['statusCode'] != 200;
  }

  Map<String, dynamic> _extractDataFromResponse(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data'] is Map ? response['data'] : response;
    }
    return response;
  }

  void _handleUnreadCountUpdate(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final countValue = parameters[0];
      int count = 0;

      if (countValue is int) {
        count = countValue;
      } else if (countValue is String) {
        try {
          final parsed = jsonDecode(countValue);
          if (parsed is Map && parsed.containsKey('count')) {
            count = parsed['count'] as int? ?? 0;
          } else {
            count = int.tryParse(countValue) ?? 0;
          }
        } catch (_) {
          count = int.tryParse(countValue) ?? 0;
        }
      }

      _unreadCountController.add(count);
      print('Unread notification count updated: $count');
    } catch (e) {
      print('Error handling unread count update: $e');
    }
  }

  void dispose() {
    disconnect();
    _notificationController.close();
    _connectionStatusController.close();
    _unreadCountController.close();
  }
}
