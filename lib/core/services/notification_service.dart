import 'dart:async';
import 'dart:convert';
import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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
    return Notification(
      id: json['Id'] as int,
      senderId: json['SenderId'] ?? 0,
      content: json['Content'] as String,
      createdAt: DateTime.parse(json['SentAt'] as String),
      isRead: json['IsSeen'] as bool,
      senderName: json['SenderName'],
      senderAvatar: json['SenderAvatar'],
      additionalData: {
        'targetType': json['TargetType'],
        'targetId': _extractTargetId(json),
      },
    );
  }

  static dynamic _extractTargetId(Map<String, dynamic> json) {
    final targetType = json['TargetType'] as String?;
    if (targetType == null) return null;

    switch (targetType) {
      case 'Message':
        return json['TargetMessageId'];
      case 'CustomerReview':
        return json['TargetCustomerReviewId'];
      case 'RenterReview':
        return json['TargetRenterReviewId'];
      case 'Booking':
        return json['TargetBookingId'];
      case 'Rental':
        return json['TargetRentalId'];
      default:
        return null;
    }
  }
}

class NotificationService {
  final ApiConsumer _apiConsumer;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  WebSocketChannel? _channel;
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

  NotificationService({required ApiConsumer apiConsumer})
      : _apiConsumer = apiConsumer;

  void setTokenRefreshCubit(TokenRefreshCubit cubit) {
    _tokenRefreshCubit = cubit;
  }

  Future<void> initialize({required int userId}) async {
    _userId = userId;
    await _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
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

      // Create new websocket connection with auth token
      final wsUrl =
          'wss://${EndPoint.baseUrl.replaceAll('https://', '')}${EndPoint.notificationHub}';
      _channel = WebSocketChannel.connect(
        Uri.parse('$wsUrl?userId=$_userId&access_token=$token'),
      );

      // Listen to incoming messages
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data['type'] == 'notification') {
            final notification = Notification.fromJson(data['data']);
            _notificationController.add(notification);
          } else if (data['type'] == 'unreadCount') {
            _unreadCountController.add(data['count']);
          }
        },
        onDone: () {
          _isConnected = false;
          _connectionController.add(false);
        },
        onError: (error) {
          _isConnected = false;
          _connectionController.add(false);
        },
      );

      _isConnected = true;
      _connectionController.add(true);
    } catch (e) {
      _isConnected = false;
      _connectionController.add(false);
      throw Exception('Failed to connect to notification service: $e');
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
      final response = await _apiConsumer.get(
        '/api/notification',
        queryParameters: {'pageNo': page, 'pageSize': pageSize},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Handle the response formats properly
      List<dynamic> notificationData = [];
      
      if (response is Map<String, dynamic>) {
        // Check for different possible response structures
        if (response.containsKey('data') && response['data'] is List) {
          notificationData = response['data'] as List<dynamic>;
        } else if (response.containsKey('items') && response['items'] is List) {
          notificationData = response['items'] as List<dynamic>;
        } else if (response.containsKey('notifications') && response['notifications'] is List) {
          notificationData = response['notifications'] as List<dynamic>;
        } else if (response.containsKey('totalPages')) {
          // This might be pagination info with data
          if (response.containsKey('data') && response['data'] is List) {
            notificationData = response['data'] as List<dynamic>;
          } else {
            // Extract all keys that contain lists and use the first one
            for (final key in response.keys) {
              if (response[key] is List && (response[key] as List).isNotEmpty) {
                notificationData = response[key] as List<dynamic>;
                break;
              }
            }
          }
        } else {
          // If no known list field, check if any field is a list
          for (final key in response.keys) {
            if (response[key] is List && (response[key] as List).isNotEmpty) {
              notificationData = response[key] as List<dynamic>;
              break;
            }
          }
        }
      } else if (response is List<dynamic>) {
        notificationData = response;
      }

      // Convert to notification objects
      return notificationData.map((json) {
        if (json is Map<String, dynamic>) {
          return Notification.fromJson(json);
        } else {
          throw Exception('Invalid notification data format');
        }
      }).toList();
    } catch (e) {
      // For API errors, return empty list instead of throwing
      if (e is DioException) {
        // Status code 204 (No Content) or 404 (Not Found) can indicate empty results
        if (e.response?.statusCode == 204 || e.response?.statusCode == 404) {
          return [];
        }
      }
      // Rethrow for other errors
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
      // First try the specific unread-count endpoint
      final response = await _apiConsumer.get(
        '/api/notification/unread-count',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Handle different response formats
      if (response is Map<String, dynamic>) {
        if (response.containsKey('count')) {
          return response['count'] as int? ?? 0;
        } else if (response.containsKey('unreadCount')) {
          return response['unreadCount'] as int? ?? 0;
        }
        // Look for any integer field as a fallback
        for (final value in response.values) {
          if (value is int) {
            return value;
          }
        }
        return 0;
      } else if (response is int) {
        return response;
      } else if (response is String) {
        // Parse string response to int
        try {
          return int.parse(response.trim());
        } catch (e) {
          return 0;
        }
      }
      
      return 0;
    } catch (e) {
      // In case of errors, return 0 as fallback
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
      await _apiConsumer.put(
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
      await _apiConsumer.put(
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

    await _apiConsumer.post(
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

  Future<void> reconnect() async {
    if (_userId == null) {
      throw Exception('Must initialize with userId before reconnecting');
    }
    await _connectWebSocket();
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _isConnected = false;
    _connectionController.add(false);
  }

  void dispose() {
    disconnect();
    _notificationController.close();
    _connectionController.close();
    _unreadCountController.close();
  }
}