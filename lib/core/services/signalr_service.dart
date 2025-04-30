import 'dart:async';
import 'dart:convert';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:aggar/core/api/end_points.dart';

/// Response model for API calls
class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String message;

  ApiResponse({
    this.data,
    required this.statusCode,
    required this.message,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse(
      data: json['Data'] != null && fromJson != null
          ? fromJson(json['Data'])
          : null,
      statusCode: json['StatusCode'] ?? 0,
      message: json['Message'] ?? '',
    );
  }
}

/// Message model
class ChatMessage {
  final int id;
  final String clientMessageId;
  final int senderId;
  final int receiverId;
  final DateTime sentAt;
  final bool seen;
  final String? content;
  final String? filePath;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.clientMessageId,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.seen,
    this.content,
    this.filePath,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {required int currentUserId}) {
    return ChatMessage(
      id: json['Id'] ?? 0,
      clientMessageId: json['ClientMessageId'] ?? '',
      senderId: json['SenderId'] ?? 0,
      receiverId: json['ReceiverId'] ?? 0,
      sentAt: json['SentAt'] != null
          ? DateTime.parse(json['SentAt'])
          : DateTime.now(),
      seen: json['Seen'] ?? false,
      content: json['Content'],
      filePath: json['FilePath'],
      isMe: json['SenderId'] == currentUserId,
    );
  }
}

/// Upload initiation response
class UploadInitiationResponse {
  final String filePath;
  final String clientMessageId;

  UploadInitiationResponse({
    required this.filePath,
    required this.clientMessageId,
  });

  factory UploadInitiationResponse.fromJson(Map<String, dynamic> json) {
    return UploadInitiationResponse(
      filePath: json['FilePath'] ?? '',
      clientMessageId: json['ClientMessageId'] ?? '',
    );
  }
}

/// Upload progress model
class UploadProgress {
  final String clientMessageId;
  final int bytesUploaded;
  final double progressPercentage;

  UploadProgress({
    required this.clientMessageId,
    required this.bytesUploaded,
    required this.progressPercentage,
  });

  factory UploadProgress.fromJson(Map<String, dynamic> json,
      {int totalBytes = 1}) {
    final bytesUploaded = json['Progress'] ?? 0;
    return UploadProgress(
      clientMessageId: json['ClientMessageId'] ?? '',
      bytesUploaded: bytesUploaded,
      progressPercentage:
          totalBytes > 0 ? (bytesUploaded / totalBytes) * 100 : 0,
    );
  }
}

/// User connection status
class UserConnectionStatus {
  final int userId;
  final bool isConnected;

  UserConnectionStatus({
    required this.userId,
    required this.isConnected,
  });
}

/// SignalR service for chat functionality
class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;
  bool _isConnected = false;
  int _currentUserId = 0;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Stream controllers
  final _messageController = StreamController<ChatMessage>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _userConnectionController =
      StreamController<UserConnectionStatus>.broadcast();
  final _uploadInitiationController =
      StreamController<UploadInitiationResponse>.broadcast();
  final _uploadProgressController =
      StreamController<UploadProgress>.broadcast();

  // Stream getters
  Stream<ChatMessage> get onMessageReceived => _messageController.stream;
  Stream<bool> get onConnectionChange => _connectionStatusController.stream;
  Stream<UserConnectionStatus> get onUserConnectionChange =>
      _userConnectionController.stream;
  Stream<UploadInitiationResponse> get onUploadInitiation =>
      _uploadInitiationController.stream;
  Stream<UploadProgress> get onUploadProgress =>
      _uploadProgressController.stream;

  // Public getters
  bool get isConnected => _isConnected;
  int get currentUserId => _currentUserId;

  /// Initialize SignalR connection
  Future<void> initialize({int? userId}) async {
    if (_isConnected) {
      print('SignalR connection already established');
      return;
    }

    try {
      if (userId != null) {
        _currentUserId = userId;
      }

      // Get access token from secure storage
      final accessToken = await _secureStorage.read(key: 'accessToken');
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Access token not found. Please login first.');
      }

      _hubConnection = HubConnectionBuilder()
          .withUrl(
              '${EndPoint.baseUrl}${EndPoint.chatHub}?access_token=$accessToken')
          .withAutomaticReconnect(
        retryDelays: [
          2000,
          5000,
          10000,
          20000,
          30000
        ], // Configure retry intervals in milliseconds
      ).build();

      _registerEventHandlers();

      await _hubConnection!.start();
      _isConnected = true;
      _connectionStatusController.add(true);

      print('SignalR connection established successfully');
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('Error establishing SignalR connection: $e');
      throw Exception('Failed to connect to chat server: $e');
    }
  }

  /// Register all event handlers
  void _registerEventHandlers() {
    _hubConnection!.on('ReceiveMessage', _handleReceiveMessage);
    _hubConnection!.on('UserConnected', _handleUserConnected);
    _hubConnection!.on('UserDisconnected', _handleUserDisconnected);
    _hubConnection!.on('UploadInitiationResponse', _handleUploadInitiation);
    _hubConnection!.on('ReceiveUploadingProgress', _handleUploadProgress);

    // Connection state handlers
    _hubConnection!.onreconnecting(({error}) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('SignalR reconnecting: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _isConnected = true;
      _connectionStatusController.add(true);
      print('SignalR reconnected with ID: $connectionId');
    });

    _hubConnection!.onclose(({error}) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('SignalR connection closed: $error');
    });
  }

  /// Close the SignalR connection
  Future<void> disconnect() async {
    if (!_isConnected || _hubConnection == null) return;

    try {
      await _hubConnection!.stop();
      _isConnected = false;
      _connectionStatusController.add(false);
      print('SignalR connection closed');
    } catch (e) {
      print('Error closing SignalR connection: $e');
    }
  }

  /// Invokes a hub method with error handling
  Future<T?> _invokeMethod<T>(String methodName, Map<String, dynamic> args,
      {T Function(dynamic)? resultConverter}) async {
    if (!_isConnected || _hubConnection == null) {
      print('Cannot invoke method: SignalR not connected');
      throw Exception('SignalR not connected');
    }

    try {
      final result = await _hubConnection!.invoke(methodName, args: [args]);
      if (resultConverter != null && result != null) {
        return resultConverter(result);
      }
      return result as T?;
    } catch (e) {
      print('Error invoking method $methodName: $e');
      throw Exception('Failed to invoke method $methodName: $e');
    }
  }

  /// Send a text message
  Future<void> sendMessage(
      {required String clientMessageId,
      required int receiverId,
      required String content}) async {
    await _invokeMethod('SendMessageAsync', {
      'clientMessageId': clientMessageId,
      'receiverId': receiverId,
      'content': content,
    });
    print('Message sent successfully');
  }

  /// Initiate file upload process
  Future<UploadInitiationResponse> initiateFileUpload({
    required String clientMessageId,
    required String fileName,
    required String fileExtension,
  }) async {
    final response = await _invokeMethod<UploadInitiationResponse>(
        'InitiateUploadingAsync', {
      'ClientMessageId': clientMessageId,
      'Name': fileName,
      'Extension': fileExtension,
    }, resultConverter: (result) {
      final Map<String, dynamic> jsonData = jsonDecode(result.toString());
      final apiResponse = ApiResponse.fromJson(
        jsonData,
        (data) => UploadInitiationResponse.fromJson(data),
      );
      return apiResponse.data!;
    });

    if (response == null) {
      throw Exception('Failed to initiate file upload');
    }

    return response;
  }

  /// Upload file chunks
  Future<void> uploadFileChunk({
    required String clientMessageId,
    required int receiverId,
    required String filePath,
    required String bytesBase64,
    required int totalBytes,
  }) async {
    await _invokeMethod(
      'UploadAsync',
      {
        'ClientMessageId': clientMessageId,
        'ReceiverId': receiverId,
        'FilePath': filePath,
        'BytesBase64': bytesBase64,
      },
    );
  }

  /// Complete file upload process
  Future<void> finishFileUpload({
    required String clientMessageId,
    required int receiverId,
    required String filePath,
    required List<int> fileBytes,
  }) async {
    // Calculate SHA-256 checksum
    final checksum = sha256.convert(fileBytes).toString();
    final checksumBase64 = base64.encode(utf8.encode(checksum));

    await _invokeMethod(
      'FinishUploadingAsync',
      {
        'ClientMessageId': clientMessageId,
        'ReceiverId': receiverId,
        'FilePath': filePath,
        'checksum': checksumBase64,
      },
    );
  }

  /// Handle received messages
  void _handleReceiveMessage(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final jsonStr = parameters[0].toString();
      final Map<String, dynamic> responseData = jsonDecode(jsonStr);

      // Extract message data from the API response
      final apiResponse = ApiResponse.fromJson(
        responseData,
        (data) => data,
      );

      if (apiResponse.data != null) {
        final messageData = apiResponse.data!;
        final message = ChatMessage.fromJson(
          messageData,
          currentUserId: _currentUserId,
        );

        _messageController.add(message);
      }
    } catch (e) {
      print('Error handling received message: $e');
    }
  }

  /// Handle user connected event
  void _handleUserConnected(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final userId = int.tryParse(parameters[0].toString()) ?? 0;
      _userConnectionController.add(UserConnectionStatus(
        userId: userId,
        isConnected: true,
      ));
      print('User connected: $userId');
    } catch (e) {
      print('Error handling user connected: $e');
    }
  }

  /// Handle user disconnected event
  void _handleUserDisconnected(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final userId = int.tryParse(parameters[0].toString()) ?? 0;
      _userConnectionController.add(UserConnectionStatus(
        userId: userId,
        isConnected: false,
      ));
      print('User disconnected: $userId');
    } catch (e) {
      print('Error handling user disconnected: $e');
    }
  }

  /// Handle upload initiation response
  void _handleUploadInitiation(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final Map<String, dynamic> responseData =
          jsonDecode(parameters[0].toString());

      final apiResponse = ApiResponse.fromJson(
        responseData,
        (data) => UploadInitiationResponse.fromJson(data),
      );

      if (apiResponse.data != null) {
        _uploadInitiationController.add(apiResponse.data!);
      }
    } catch (e) {
      print('Error handling upload initiation: $e');
    }
  }

  /// Handle upload progress updates
  void _handleUploadProgress(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final Map<String, dynamic> responseData =
          jsonDecode(parameters[0].toString());

      final apiResponse = ApiResponse.fromJson(
        responseData,
        (data) => data,
      );

      if (apiResponse.data != null) {
        // We need the total bytes to calculate percentage
        // This would need to be stored separately when initiating an upload
        final uploadProgress = UploadProgress.fromJson(apiResponse.data!);
        _uploadProgressController.add(uploadProgress);
      }
    } catch (e) {
      print('Error handling upload progress: $e');
    }
  }

  /// Get current connection ID
  String? get connectionId => _hubConnection?.connectionId;

  /// Dispose method to clean up resources
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionStatusController.close();
    _userConnectionController.close();
    _uploadInitiationController.close();
    _uploadProgressController.close();
  }
}
