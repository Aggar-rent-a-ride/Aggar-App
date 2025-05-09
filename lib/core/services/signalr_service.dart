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

  static const int _maxChunkSize = 1024 * 1024; // 1MB max chunk size
  static const Duration _uploadTimeout = Duration(seconds: 30);

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
    if (_isConnected && _hubConnection?.connectionId != null) {
      print(
          'SignalR connection already established with ID: ${_hubConnection?.connectionId}');
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

      if (_hubConnection != null) {
        await _hubConnection!.stop();
        _hubConnection = null;
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

      if (_hubConnection?.connectionId == null) {
        throw Exception('Failed to obtain SignalR connection ID');
      }

      _isConnected = true;
      _connectionStatusController.add(true);

      print(
          'SignalR connection established successfully with ID: ${_hubConnection?.connectionId}');
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

  Future<UploadInitiationResponse> initiateFileUpload({
    required String clientMessageId,
    required String fileName,
    required String fileExtension,
  }) async {
    try {
      if (clientMessageId.isEmpty) {
        throw Exception('Client message ID cannot be empty');
      }
      if (fileName.isEmpty) {
        throw Exception('File name cannot be empty');
      }
      if (fileExtension.isEmpty) {
        throw Exception('File extension cannot be empty');
      }

      final normalizedExtension = fileExtension.toLowerCase();

      final extensionWithDot = normalizedExtension.startsWith('.')
          ? normalizedExtension
          : '.$normalizedExtension';

      String cleanFileName = fileName;
      if (fileName.toLowerCase().endsWith(extensionWithDot)) {
        cleanFileName =
            fileName.substring(0, fileName.length - extensionWithDot.length);
      }

      if (cleanFileName.isEmpty) {
        throw Exception('File name cannot be empty after removing extension');
      }

      print('Initiating file upload with parameters:');
      print('ClientMessageId: $clientMessageId');
      print('FileName: $cleanFileName');
      print('FileExtension: $extensionWithDot');

      if (!_isConnected || _hubConnection == null) {
        await initialize(userId: _currentUserId);
        if (!_isConnected) {
          throw Exception('SignalR is not connected');
        }
      }

      print('Using SignalR connection ID: ${_hubConnection!.connectionId}');

      final args = {
        'clientMessageId': clientMessageId,
        'name': cleanFileName,
        'extension': extensionWithDot,
      };

      print('Invoking InitiateUploadingAsync with args: $args');

      // Create a completer to handle the async response
      final completer = Completer<UploadInitiationResponse>();

      StreamSubscription? subscription;
      subscription = _uploadInitiationController.stream.listen((response) {
        if (response.clientMessageId == clientMessageId) {
          subscription?.cancel();
          completer.complete(response);
        }
      }, onError: (error) {
        subscription?.cancel();
        completer.completeError(error);
      });

      Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          subscription?.cancel();
          completer.completeError(Exception('Upload initiation timed out'));
        }
      });

      final result = await _hubConnection!.invoke(
        'InitiateUploadingAsync',
        args: [args],
      );

      print('Hub method invocation result: $result');

      if (result != null) {
        try {
          final Map<String, dynamic> responseData = result is String
              ? jsonDecode(result)
              : (result is Map ? result.cast<String, dynamic>() : {});

          if (responseData.containsKey('statusCode') &&
              responseData['statusCode'] == 500) {
            throw Exception(responseData['message'] ?? 'Server error occurred');
          }
        } catch (e) {
          print('Error parsing immediate response: $e');
        }
      }

      final response = await completer.future;

      if (response.filePath.isEmpty) {
        throw Exception('Server returned empty file path');
      }

      return response;
    } catch (e) {
      print('Error initiating file upload: $e');
      rethrow;
    }
  }

  /// Upload file chunks
  Future<void> uploadFileChunk({
    required String clientMessageId,
    required int receiverId,
    required String filePath,
    required String bytesBase64,
    required int totalBytes,
  }) async {
    print('Uploading chunk:');
    print('ClientMessageId: $clientMessageId');
    print('ReceiverId: $receiverId');
    print('FilePath: $filePath');
    print('BytesBase64 length: ${bytesBase64.length}');

    if (bytesBase64.length > _maxChunkSize) {
      throw Exception(
          'Chunk size (${bytesBase64.length} bytes) exceeds maximum allowed size of $_maxChunkSize bytes');
    }

    try {
      final result = await _invokeMethod(
        'UploadAsync',
        {
          'ClientMessageId': clientMessageId,
          'ReceiverId': receiverId,
          'FilePath': filePath,
          'BytesBase64': bytesBase64,
        },
      ).timeout(
        _uploadTimeout,
        onTimeout: () => throw Exception(
            'Chunk upload timed out after ${_uploadTimeout.inSeconds} seconds'),
      );
      print('Chunk upload result: $result');
    } catch (e) {
      print('Error uploading chunk: $e');
      rethrow;
    }
  }

  /// Complete file upload process
  Future<ChatMessage> finishFileUpload({
    required String clientMessageId,
    required int receiverId,
    required String filePath,
    required List<int> fileBytes,
  }) async {
    try {
      final hash = sha256.convert(fileBytes);
      final checksumBase64 = base64.encode(hash.bytes);
      print('Calculated checksum (base64): $checksumBase64');

      final completer = Completer<ChatMessage>();

      StreamSubscription? subscription;
      subscription = _messageController.stream.listen(
        (message) {
          if (message.clientMessageId == clientMessageId) {
            subscription?.cancel();
            completer.complete(message);
          }
        },
        onError: (error) {
          subscription?.cancel();
          completer.completeError(error);
        },
      );

      Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          subscription?.cancel();
          completer.completeError(
              Exception('Finish upload timed out after 30 seconds'));
        }
      });

      final result = await _invokeMethod<Map<String, dynamic>>(
        'FinishUploadingAsync',
        {
          'ClientMessageId': clientMessageId,
          'ReceiverId': receiverId,
          'FilePath': filePath,
          'checksum': checksumBase64,
        },
        resultConverter: (dynamic response) {
          if (response is String) {
            return jsonDecode(response) as Map<String, dynamic>;
          }
          return response as Map<String, dynamic>;
        },
      ).timeout(
        _uploadTimeout,
        onTimeout: () => throw Exception(
            'Finish upload timed out after ${_uploadTimeout.inSeconds} seconds'),
      );

      // Check for error response
      if (result != null) {
        final statusCode = result['statusCode'];
        if (statusCode != null && statusCode != 200) {
          final errorMessage = result['message'] ?? 'Server error occurred';
          throw Exception(errorMessage);
        }

        if (result['data'] != null) {
          final message = ChatMessage.fromJson(
            result['data'],
            currentUserId: _currentUserId,
          );
          return message;
        }
      }

      return await completer.future;
    } catch (e) {
      print('Error finishing file upload: $e');
      rethrow;
    }
  }

  /// Handle received messages
  void _handleReceiveMessage(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      String responseStr = parameters[0].toString();
      print('Received message: $responseStr');

      responseStr = responseStr.replaceAllMapped(
        RegExp(r'(\w+):'),
        (match) => '"${match.group(1)}":',
      );
      responseStr = responseStr.replaceAllMapped(
        RegExp(r':\s*([^",\{\}\[\]\s][^,\{\}\[\]]*[^",\{\}\[\]\s])'),
        (match) => ': "${match.group(1)}"',
      );

      final Map<String, dynamic> responseData = jsonDecode(responseStr);
      print('Parsed message data: $responseData');

      if (responseData['statusCode'] != null &&
          responseData['statusCode'] != 200) {
        final errorMessage =
            responseData['message'] ?? 'Unknown error occurred';
        print('Error response received: $errorMessage');
        _messageController.addError(errorMessage);
        return;
      }
      if (responseData['data'] == null) {
        print('Received message with null data');
        return;
      }
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        final message = ChatMessage.fromJson(
          data,
          currentUserId: _currentUserId,
        );
        _messageController.add(message);
      } else {
        print('Invalid data format in message: $data');
      }
    } catch (e) {
      print('Error handling received message: $e');
      _messageController.addError('Failed to process message: $e');
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
      print('Received upload initiation response: $parameters');

      String responseStr = parameters[0].toString();
      print('Raw response string: $responseStr');

      responseStr = responseStr.replaceAllMapped(
        RegExp(r'(\w+):'),
        (match) => '"${match.group(1)}":',
      );
      responseStr = responseStr.replaceAllMapped(
        RegExp(r':\s*([^",\{\}\[\]\s][^,\{\}\[\]]*[^",\{\}\[\]\s])'),
        (match) => ': "${match.group(1)}"',
      );

      print('Formatted response string: $responseStr');

      final Map<String, dynamic> responseData = jsonDecode(responseStr);
      print('Parsed response data: $responseData');

      if (responseData.containsKey('statusCode') &&
          responseData['statusCode'] == 500) {
        final errorMessage = responseData['message'] ?? 'Server error occurred';
        print('Server error: $errorMessage');
        _uploadInitiationController.addError(errorMessage);
        return;
      }

      if (responseData.containsKey('data')) {
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          final response = UploadInitiationResponse(
            filePath: data['filePath'] ?? data['FilePath'] ?? '',
            clientMessageId:
                data['clientMessageId'] ?? data['ClientMessageId'] ?? '',
          );

          if (response.filePath.isEmpty) {
            print('Error: Server returned empty file path in API response');
            _uploadInitiationController
                .addError('Server returned empty file path');
            return;
          }

          print('Emitting API response data: $response');
          _uploadInitiationController.add(response);
        } else {
          print('Error: Invalid data format in API response');
          _uploadInitiationController
              .addError('Invalid data format in response');
        }
      } else {
        final response = UploadInitiationResponse(
          filePath: responseData['filePath'] ?? responseData['FilePath'] ?? '',
          clientMessageId: responseData['clientMessageId'] ??
              responseData['ClientMessageId'] ??
              '',
        );

        if (response.filePath.isEmpty) {
          print('Error: Server returned empty file path in direct response');
          _uploadInitiationController
              .addError('Server returned empty file path');
          return;
        }

        print('Emitting direct response data: $response');
        _uploadInitiationController.add(response);
      }
    } catch (e) {
      print('Error handling upload initiation: $e');
      _uploadInitiationController
          .addError('Failed to parse server response: $e');
    }
  }

  /// Handle upload progress updates
  void _handleUploadProgress(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      String responseStr = parameters[0].toString();
      print('Received upload progress: $responseStr');

      responseStr = responseStr.replaceAllMapped(
        RegExp(r'(\w+):'),
        (match) => '"${match.group(1)}":',
      );
      responseStr = responseStr.replaceAllMapped(
        RegExp(r':\s*([^",\{\}\[\]\s][^,\{\}\[\]]*[^",\{\}\[\]\s])'),
        (match) => ': "${match.group(1)}"',
      );

      final Map<String, dynamic> responseData = jsonDecode(responseStr);
      print('Parsed progress data: $responseData');

      if (responseData.containsKey('data')) {
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          final progress = data['progress'];
          int progressInt;
          if (progress is String) {
            progressInt = int.tryParse(progress) ?? 0;
          } else if (progress is int) {
            progressInt = progress;
          } else {
            progressInt = 0;
          }

          final totalBytes = data['totalBytes'] as int? ?? 0;

          final uploadProgress = UploadProgress(
            clientMessageId:
                data['clientMessageId'] ?? data['ClientMessageId'] ?? '',
            bytesUploaded: progressInt,
            progressPercentage:
                totalBytes > 0 ? (progressInt / totalBytes) * 100 : 0,
          );
          _uploadProgressController.add(uploadProgress);
        }
      }
    } catch (e) {
      print('Error handling upload progress: $e');
      _uploadProgressController
          .addError('Failed to process upload progress: $e');
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
