import 'dart:async';
import 'dart:convert';
import 'package:aggar/core/services/signalr_service_component.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:aggar/core/api/end_points.dart';

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

  final _messageController = StreamController<ChatMessage>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _userConnectionController =
      StreamController<UserConnectionStatus>.broadcast();
  final _uploadInitiationController =
      StreamController<UploadInitiationResponse>.broadcast();
  final _uploadProgressController =
      StreamController<UploadProgress>.broadcast();

  Stream<ChatMessage> get onMessageReceived => _messageController.stream;
  Stream<bool> get onConnectionChange => _connectionStatusController.stream;
  Stream<UserConnectionStatus> get onUserConnectionChange =>
      _userConnectionController.stream;
  Stream<UploadInitiationResponse> get onUploadInitiation =>
      _uploadInitiationController.stream;
  Stream<UploadProgress> get onUploadProgress =>
      _uploadProgressController.stream;

  bool get isConnected => _isConnected;
  int get currentUserId => _currentUserId;

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
        retryDelays: [2000, 5000, 10000, 20000, 30000],
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
      throw Exception('Failed to connect to chat server: $e');
    }
  }

  void _registerEventHandlers() {
    _hubConnection!.on('ReceiveMessage', _handleReceiveMessage);
    _hubConnection!.on('UserConnected', _handleUserConnected);
    _hubConnection!.on('UserDisconnected', _handleUserDisconnected);
    _hubConnection!.on('UploadInitiationResponse', _handleUploadInitiation);
    _hubConnection!.on('ReceiveUploadingProgress', _handleUploadProgress);

    _hubConnection!.onreconnecting(({error}) {
      _isConnected = false;
      _connectionStatusController.add(false);
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _isConnected = true;
      _connectionStatusController.add(true);
    });

    _hubConnection!.onclose(({error}) {
      _isConnected = false;
      _connectionStatusController.add(false);
    });
  }

  Future<void> disconnect() async {
    if (!_isConnected || _hubConnection == null) return;

    try {
      await _hubConnection!.stop();
      _isConnected = false;
      _connectionStatusController.add(false);
    } catch (e) {}
  }

  Future<T?> _invokeMethod<T>(String methodName, Map<String, dynamic> args,
      {T Function(dynamic)? resultConverter}) async {
    if (!_isConnected || _hubConnection == null) {
      throw Exception('SignalR not connected');
    }

    try {
      final result = await _hubConnection!.invoke(methodName, args: [args]);
      if (resultConverter != null && result != null) {
        return resultConverter(result);
      }
      return result as T?;
    } catch (e) {
      throw Exception('Failed to invoke method $methodName: $e');
    }
  }

  Future<void> sendMessage(
      {required String clientMessageId,
      required int receiverId,
      required String content}) async {
    await _invokeMethod('SendMessageAsync', {
      'clientMessageId': clientMessageId,
      'receiverId': receiverId,
      'content': content,
    });
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

      if (!_isConnected || _hubConnection == null) {
        await initialize(userId: _currentUserId);
        if (!_isConnected) {
          throw Exception('SignalR is not connected');
        }
      }

      final args = {
        'clientMessageId': clientMessageId,
        'name': cleanFileName,
        'extension': extensionWithDot,
      };

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

      if (result != null) {
        try {
          final Map<String, dynamic> responseData = result is String
              ? jsonDecode(result)
              : (result is Map ? result.cast<String, dynamic>() : {});

          if (responseData.containsKey('statusCode') &&
              responseData['statusCode'] == 500) {
            throw Exception(responseData['message'] ?? 'Server error occurred');
          }
        } catch (e) {}
      }

      final response = await completer.future;

      if (response.filePath.isEmpty) {
        throw Exception('Server returned empty file path');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadFileChunk({
    required String clientMessageId,
    required int receiverId,
    required String filePath,
    required String bytesBase64,
    required int totalBytes,
  }) async {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatMessage> finishFileUpload({
    required String clientMessageId,
    required int receiverId,
    required String filePath,
    required List<int> fileBytes,
  }) async {
    try {
      final hash = sha256.convert(fileBytes);
      final checksumBase64 = base64.encode(hash.bytes);

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
      rethrow;
    }
  }

  void _handleReceiveMessage(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final rawResponse = parameters[0];

      Map<String, dynamic> responseData;

      // ✅ BETTER APPROACH: Handle different response formats
      if (rawResponse is Map<String, dynamic>) {
        // Response is already a Map
        responseData = rawResponse;
      } else if (rawResponse is String) {
        // Try to parse as JSON string
        try {
          responseData = jsonDecode(rawResponse);
        } catch (jsonError) {
          // If JSON parsing fails, try the regex approach as fallback
          String responseStr = rawResponse;

          // More conservative regex that only targets clear property names
          responseStr = responseStr.replaceAllMapped(
            RegExp(r'\b(\w+)(?=\s*:)(?![^{]*})'),
            (match) => '"${match.group(1)}"',
          );

          responseData = jsonDecode(responseStr);
        }
      } else {
        // Convert to string and try to parse
        String responseStr = rawResponse.toString();
        responseData = jsonDecode(responseStr);
      }

      // Check for error response
      if (responseData['statusCode'] != null &&
          responseData['statusCode'] != 200 &&
          responseData['statusCode'] != 201) {
        final errorMessage =
            responseData['message'] ?? 'Unknown error occurred';
        _messageController.addError(errorMessage);
        return;
      }

      if (responseData['data'] == null) {
        return;
      }

      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        // ✅ FIXED: Handle both camelCase and PascalCase property names
        final processedData = <String, dynamic>{};

        data.forEach((key, value) {
          // Convert PascalCase to camelCase for consistency
          String normalizedKey = key;
          if (key.length > 1) {
            normalizedKey = key[0].toLowerCase() + key.substring(1);
          }

          // Handle both formats
          switch (normalizedKey.toLowerCase()) {
            case 'id':
              processedData['Id'] = value;
              break;
            case 'clientmessageid':
              processedData['ClientMessageId'] = value;
              break;
            case 'senderid':
              processedData['SenderId'] = value;
              break;
            case 'receiverid':
              processedData['ReceiverId'] = value;
              break;
            case 'sentat':
              processedData['SentAt'] = value;
              break;
            case 'isseen':
            case 'seen':
              processedData['Seen'] = value;
              break;
            case 'content':
              processedData['Content'] = value;
              break;
            case 'filepath':
              processedData['FilePath'] = value;
              break;
            default:
              processedData[key] = value;
          }
        });

        final message = ChatMessage.fromJson(
          processedData,
          currentUserId: _currentUserId,
        );
        _messageController.add(message);
      } else {
        print('Invalid data format in message: $data');
      }
    } catch (e) {
      _messageController.addError('Failed to process message: $e');
    }
  }

  void _handleUserConnected(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final userId = int.tryParse(parameters[0].toString()) ?? 0;
      _userConnectionController.add(UserConnectionStatus(
        userId: userId,
        isConnected: true,
      ));
    } catch (e) {}
  }

  void _handleUserDisconnected(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final userId = int.tryParse(parameters[0].toString()) ?? 0;
      _userConnectionController.add(UserConnectionStatus(
        userId: userId,
        isConnected: false,
      ));
    } catch (e) {}
  }

  void _handleUploadInitiation(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final rawResponse = parameters[0];

      Map<String, dynamic> responseData;

      // Handle different response formats
      if (rawResponse is Map<String, dynamic>) {
        responseData = rawResponse;
      } else if (rawResponse is String) {
        try {
          responseData = jsonDecode(rawResponse);
        } catch (jsonError) {
          String responseStr = rawResponse;
          responseStr = responseStr.replaceAllMapped(
            RegExp(r'\b(\w+)(?=\s*:)(?![^{]*})'),
            (match) => '"${match.group(1)}"',
          );

          responseData = jsonDecode(responseStr);
        }
      } else {
        String responseStr = rawResponse.toString();
        responseData = jsonDecode(responseStr);
      }

      if (responseData.containsKey('statusCode') &&
          responseData['statusCode'] == 500) {
        final errorMessage = responseData['message'] ?? 'Server error occurred';
        _uploadInitiationController.addError(errorMessage);
        return;
      }

      String filePath = '';
      String clientMessageId = '';

      if (responseData.containsKey('data')) {
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          filePath = data['filePath'] ?? data['FilePath'] ?? '';
          clientMessageId =
              data['clientMessageId'] ?? data['ClientMessageId'] ?? '';
        }
      } else {
        filePath = responseData['filePath'] ?? responseData['FilePath'] ?? '';
        clientMessageId = responseData['clientMessageId'] ??
            responseData['ClientMessageId'] ??
            '';
      }

      if (filePath.isEmpty) {
        _uploadInitiationController.addError('Server returned empty file path');
        return;
      }

      final response = UploadInitiationResponse(
        filePath: filePath,
        clientMessageId: clientMessageId,
      );

      _uploadInitiationController.add(response);
    } catch (e) {
      _uploadInitiationController
          .addError('Failed to parse server response: $e');
    }
  }

  void _handleUploadProgress(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      final rawResponse = parameters[0];

      Map<String, dynamic> responseData;

      // Handle different response formats
      if (rawResponse is Map<String, dynamic>) {
        responseData = rawResponse;
      } else if (rawResponse is String) {
        try {
          responseData = jsonDecode(rawResponse);
        } catch (jsonError) {
          String responseStr = rawResponse;
          responseStr = responseStr.replaceAllMapped(
            RegExp(r'\b(\w+)(?=\s*:)(?![^{]*})'),
            (match) => '"${match.group(1)}"',
          );

          responseData = jsonDecode(responseStr);
        }
      } else {
        String responseStr = rawResponse.toString();
        responseData = jsonDecode(responseStr);
      }

      Map<String, dynamic>? data;
      if (responseData.containsKey('data')) {
        data = responseData['data'] as Map<String, dynamic>?;
      } else {
        data = responseData;
      }

      if (data != null) {
        final progress = data['progress'] ?? data['Progress'] ?? 0;
        int progressInt;

        if (progress is String) {
          progressInt = int.tryParse(progress) ?? 0;
        } else if (progress is int) {
          progressInt = progress;
        } else if (progress is double) {
          progressInt = progress.round();
        } else {
          progressInt = 0;
        }

        final totalBytes =
            (data['totalBytes'] ?? data['TotalBytes'] ?? 0) as int;
        final clientMessageId =
            data['clientMessageId'] ?? data['ClientMessageId'] ?? '';

        final uploadProgress = UploadProgress(
          clientMessageId: clientMessageId,
          bytesUploaded: progressInt,
          progressPercentage:
              totalBytes > 0 ? (progressInt / totalBytes) * 100 : 0,
        );

        _uploadProgressController.add(uploadProgress);
      }
    } catch (e) {
      _uploadProgressController
          .addError('Failed to process upload progress: $e');
    }
  }

  String? get connectionId => _hubConnection?.connectionId;

  void dispose() {
    disconnect();
    _messageController.close();
    _connectionStatusController.close();
    _userConnectionController.close();
    _uploadInitiationController.close();
    _uploadProgressController.close();
  }
}
