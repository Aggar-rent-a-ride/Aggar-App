import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class RealTimeChatCubit extends Cubit<RealTimeChatState> {
  RealTimeChatCubit() : super(const RealTimeChatInitial()) {
    _initServices();
  }

  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final SignalRService _signalRService = SignalRService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TextEditingController messageController = TextEditingController();

  ScrollController scrollController = ScrollController();

  bool _isSendingMessage = false;
  bool _isUploadingFile = false;
  final Map<String, double> _fileUploadProgress = {};
  final Map<String, String> _pendingUploads = {};
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  List<MessageModel> _messages = [];
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionStatusSubscription;
  StreamSubscription? _uploadProgressSubscription;

  int? _receiverId = 0;
  int _senderId = 0;

  bool get isUploadingFile => _isUploadingFile;
  bool get isConnected => _signalRService.isConnected;
  Map<String, double> get fileUploadProgress => _fileUploadProgress;
  Map<String, String> get pendingUploads => _pendingUploads;
  List<MessageModel> get messages => _messages;
  int get senderId => _senderId;
  int? get receiverId => _receiverId;

  Future<void> _initServices() async {
    await initializeSenderId();

    _messageSubscription = _signalRService.onMessageReceived.listen((message) {
      _handleIncomingMessage(message);
    });

    _connectionStatusSubscription =
        _signalRService.onConnectionChange.listen((isConnected) {
      emit(ConnectionStatusChanged(isConnected));

      if (isConnected) {
        _reconnectAttempts = 0;
        emit(const RealTimeChatInitial());
      } else if (!_isReconnecting &&
          _reconnectAttempts < _maxReconnectAttempts) {
        _attemptReconnection();
      } else if (_reconnectAttempts >= _maxReconnectAttempts) {
        emit(const RealTimeChatFailure(
            "Connection to chat server lost. Please reconnect manually."));
      }
    });

    _uploadProgressSubscription =
        _signalRService.onUploadProgress.listen((progress) {
      if (_fileUploadProgress.containsKey(progress.clientMessageId)) {
        _fileUploadProgress[progress.clientMessageId] =
            progress.progressPercentage;
        emit(FileUploadInProgress(
            progress.clientMessageId,
            _pendingUploads[progress.clientMessageId] ?? "Unknown file",
            progress.progressPercentage));
      }
    });
  }

  Future<void> _attemptReconnection() async {
    if (_isReconnecting) return;

    _isReconnecting = true;
    _reconnectAttempts++;

    emit(const RealTimeChatLoading());

    try {
      await _signalRService.initialize(userId: _senderId);
      if (_signalRService.isConnected) {
        _isReconnecting = false;
        emit(const RealTimeChatInitial());
      } else {
        // Exponential backoff for reconnection
        final waitTime = Duration(seconds: _reconnectAttempts * 2);
        await Future.delayed(waitTime);
        _isReconnecting = false;

        if (_reconnectAttempts < _maxReconnectAttempts) {
          _attemptReconnection();
        } else {
          emit(const RealTimeChatFailure(
              "Failed to reconnect after multiple attempts. Please try manually reconnecting."));
        }
      }
    } catch (e) {
      _isReconnecting = false;
      emit(RealTimeChatFailure("Reconnection error: ${e.toString()}"));

      if (_reconnectAttempts < _maxReconnectAttempts) {
        final waitTime = Duration(seconds: _reconnectAttempts * 2);
        await Future.delayed(waitTime);
        _attemptReconnection();
      }
    }
  }

  void _handleIncomingMessage(ChatMessage message) {
    print(
        "Received message: ${message.content} from ${message.senderId} to ${message.receiverId}");

    if ((message.senderId == _receiverId && message.receiverId == _senderId) ||
        (message.senderId == _senderId && message.receiverId == _receiverId)) {
      final newMessage = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sentAt: message.sentAt.toIso8601String(),
        isSeen: message.seen,
        content: message.content,
        filePath: message.filePath,
        isOptimistic: false,
      );

      int existingIndex = _messages.indexWhere((m) =>
          m.senderId == message.senderId &&
          m.content == message.content &&
          m.isOptimistic == true);

      if (existingIndex != -1) {
        _messages[existingIndex] = newMessage;
        emit(MessageUpdatedState(newMessage));
      } else {
        _messages.insert(0, newMessage);
        emit(MessageAddedState(newMessage));
      }
      _scrollToBottomImmediate();
    }
  }

  void setMessages(List<MessageModel> messageList) {
    _messages = List<MessageModel>.from(messageList);
    _scrollToBottomImmediate();
  }

  void _scrollToBottomImmediate() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void setReceiverId(int id) {
    _receiverId = id;
    print('Receiver ID set to: $_receiverId');
    _ensureConnected();
  }

  Future<bool> _ensureConnected() async {
    if (!_signalRService.isConnected) {
      try {
        emit(const RealTimeChatLoading());
        await _signalRService.initialize(userId: _senderId);
        emit(ConnectionStatusChanged(_signalRService.isConnected));

        if (_signalRService.isConnected) {
          emit(const RealTimeChatInitial());
        } else {
          emit(const RealTimeChatFailure("Failed to connect to chat server"));
        }

        return _signalRService.isConnected;
      } catch (e) {
        print('Failed to connect to SignalR: $e');
        emit(RealTimeChatFailure("Connection error: ${e.toString()}"));
        return false;
      }
    }
    return true;
  }

  Future<void> initializeSenderId() async {
    try {
      final userIdStr = await _secureStorage.read(key: 'userId');
      print('Retrieved userId from secure storage: $userIdStr');

      int parsedId = 0;

      if (userIdStr != null && userIdStr.isNotEmpty) {
        try {
          parsedId = int.parse(userIdStr);
        } catch (parseError) {
          print('Error parsing user ID: $parseError');
        }
      }
      if (parsedId == 0) {
        try {
          final accessToken = await _secureStorage.read(key: 'accessToken');
          if (accessToken != null && accessToken.isNotEmpty) {
            final Map<String, dynamic> decodedToken =
                JwtDecoder.decode(accessToken);
            final userId = decodedToken['sub'] ??
                decodedToken['uid'] ??
                decodedToken['userId'];

            if (userId != null) {
              if (userId is int) {
                parsedId = userId;
              } else if (userId is String) {
                parsedId = int.tryParse(userId) ?? 0;
              }
              if (parsedId > 0) {
                await _secureStorage.write(
                    key: 'userId', value: parsedId.toString());
                print('Updated userId in secure storage: $parsedId');
              }
            }
          }
        } catch (tokenError) {
          print('Error extracting user ID from token: $tokenError');
        }
      }
      _senderId = parsedId;
      print('Sender ID initialized: $_senderId');
      emit(SenderIdInitialized(_senderId));
    } catch (e) {
      print('Error retrieving sender ID: $e');
      _senderId = 0;
      print('Using fallback sender ID after error: $_senderId');
      emit(SenderIdInitialized(_senderId));
    }
  }

  Future<void> sendMessage([String? accessToken]) async {
    if (_receiverId == null) {
      emit(const RealTimeChatFailure("Receiver ID is not set"));
      return;
    }

    if (messageController.text.trim().isEmpty || _isSendingMessage) {
      return;
    }

    _isSendingMessage = true;
    final messageContent = messageController.text.trim();
    messageController.clear();

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final clientMessageId = const Uuid().v4();

    try {
      _addLocalMessage(tempId, messageContent, isOptimistic: true);
      _ensureConnected().then((isConnected) async {
        if (!isConnected) {
          return;
        }

        await _signalRService.sendMessage(
          clientMessageId: clientMessageId,
          receiverId: _receiverId!,
          content: messageContent,
        );

        _updateMessageId(tempId, clientMessageId);
        emit(MessageSentSuccessfully(clientMessageId));
      }).catchError((e) {
        print("Error sending message: $e");
        emit(RealTimeChatFailure("Failed to send message: ${e.toString()}"));
      });
    } catch (e) {
      print("Critical error sending message: $e");
      _removeMessage(tempId);
      emit(RealTimeChatFailure("Failed to send message: ${e.toString()}"));
    } finally {
      _isSendingMessage = false;
    }
  }

  void _addLocalMessage(String messageId, String content,
      {bool isOptimistic = false}) {
    final now = DateTime.now().toIso8601String();

    int numericId;
    try {
      numericId = int.parse(
          messageId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 9));
    } catch (e) {
      numericId = DateTime.now().millisecondsSinceEpoch % 1000000000;
    }

    final newMessage = MessageModel(
      id: numericId,
      senderId: _senderId,
      receiverId: _receiverId!,
      sentAt: now,
      isSeen: false,
      content: content,
      filePath: null,
      isOptimistic: isOptimistic,
    );

    _messages.insert(0, newMessage);
    emit(MessageAddedState(newMessage));
    _scrollToBottomImmediate();
  }

  void _removeMessage(String tempId) {
    _messages.removeWhere((msg) => msg.id.toString() == tempId);
    emit(const RealTimeChatInitial());
  }

  void _updateMessageId(String tempId, String newId) {
    final index = _messages.indexWhere((msg) => msg.id.toString() == tempId);
    if (index != -1) {
      final message = _messages[index];

      int newNumericId;
      try {
        newNumericId =
            int.parse(newId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 9));
      } catch (e) {
        newNumericId = DateTime.now().millisecondsSinceEpoch % 1000000000;
      }

      _messages[index] = MessageModel(
        id: newNumericId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sentAt: message.sentAt,
        isSeen: message.isSeen,
        content: message.content,
        filePath: message.filePath,
        isOptimistic: false,
      );

      emit(MessageUpdatedState(_messages[index]));
    }
  }

  Future<void> pickAndSendFile() async {
    print("pickAndSendFile called");
    if (_receiverId == null) {
      emit(const RealTimeChatFailure("Receiver ID is not set"));
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.path != null) {
          final File fileObj = File(file.path!);
          if (!await fileObj.exists()) {
            emit(const RealTimeChatFailure("File does not exist"));
            return;
          }
          final bytes = await fileObj.readAsBytes();

          final fileName = path.basename(file.path!);
          final fileExtension =
              path.extension(file.path!).replaceFirst('.', '');

          await sendFile(
            fileName,
            bytes,
            fileName,
            fileExtension,
          );
        } else if (file.bytes != null) {
          final bytes = file.bytes!;
          final fileName = file.name;
          final fileExtension = path.extension(fileName).replaceFirst('.', '');

          await sendFile(
            fileName,
            bytes,
            fileName,
            fileExtension,
          );
        } else {
          emit(const RealTimeChatFailure("Could not read file"));
        }
      } else {}
    } catch (e) {
      emit(RealTimeChatFailure("Failed to pick file: ${e.toString()}"));
    }
  }

  Future<void> sendFile(String filePath, List<int> fileBytes, String fileName,
      String fileExtension) async {
    print(
        "sendFile called with fileName: $fileName, fileExtension: $fileExtension, fileBytes length: ${fileBytes.length}");
    if (_receiverId == null) {
      emit(const RealTimeChatFailure("Receiver ID is not set"));
      return;
    }

    if (_isUploadingFile) {
      emit(const RealTimeChatFailure("A file upload is already in progress"));
      return;
    }

    _isUploadingFile = true;
    final clientMessageId = const Uuid().v4();
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    _addLocalFileMessage(clientMessageId, "uploading://$fileName", fileName,
        isOptimistic: true);

    _pendingUploads[clientMessageId] = fileName;
    _fileUploadProgress[clientMessageId] = 0.0;
    emit(FileUploadInProgress(clientMessageId, fileName, 0.0));

    try {
      if (!await _ensureConnected()) {
        _isUploadingFile = false;
        _cleanupUpload(clientMessageId);
        return;
      }

      final response = await _signalRService.initiateFileUpload(
        clientMessageId: clientMessageId,
        fileName: fileName,
        fileExtension: fileExtension,
      );

      final serverFilePath = response.filePath;
      if (serverFilePath.isEmpty) {
        throw Exception("Server returned empty file path");
      }
      const int chunkSize = 2048;
      int totalBytesSent = 0;

      for (int i = 0; i < fileBytes.length; i += chunkSize) {
        final end = (i + chunkSize < fileBytes.length)
            ? i + chunkSize
            : fileBytes.length;
        final chunk = fileBytes.sublist(i, end);
        final bytesBase64 = base64.encode(chunk);

        await _signalRService.uploadFileChunk(
          clientMessageId: clientMessageId,
          receiverId: _receiverId!,
          filePath: serverFilePath,
          bytesBase64: bytesBase64,
          totalBytes: fileBytes.length,
        );
        totalBytesSent += chunk.length;
        final localProgressPercent =
            (totalBytesSent / fileBytes.length * 100).clamp(0.0, 100.0);
        _fileUploadProgress[clientMessageId] = localProgressPercent;
        emit(FileUploadInProgress(
            clientMessageId, fileName, localProgressPercent));
      }

      await _signalRService.finishFileUpload(
        clientMessageId: clientMessageId,
        receiverId: _receiverId!,
        filePath: serverFilePath,
        fileBytes: fileBytes,
      );

      _fileUploadProgress[clientMessageId] = 100.0;
      emit(FileUploadComplete(clientMessageId, fileName));
      _updateFileMessage(tempId, clientMessageId, serverFilePath);

      Future.delayed(const Duration(seconds: 1), () {
        _cleanupUpload(clientMessageId);
      });
    } catch (e) {
      emit(FileUploadFailed(clientMessageId, fileName, e.toString()));
    } finally {
      _isUploadingFile = false;
    }
  }

  void _addLocalFileMessage(
      String clientMessageId, String filePath, String fileName,
      {bool isOptimistic = false}) {
    if (_receiverId == null) return;

    final now = DateTime.now().toIso8601String();
    int numericId;
    try {
      numericId = int.parse(
          clientMessageId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 9));
    } catch (e) {
      numericId = DateTime.now().millisecondsSinceEpoch % 1000000000;
    }

    final newMessage = MessageModel(
      id: numericId,
      senderId: _senderId,
      receiverId: _receiverId!,
      sentAt: now,
      isSeen: false,
      content: null,
      filePath: filePath,
      isOptimistic: isOptimistic,
    );
    _messages.insert(0, newMessage);
    emit(MessageAddedState(newMessage));
    _scrollToBottomImmediate();
  }

  void _updateFileMessage(String tempId, String newId, String serverFilePath) {
    final index = _messages.indexWhere((msg) => msg.id.toString() == tempId);

    if (index != -1) {
      final message = _messages[index];

      int newNumericId;
      try {
        newNumericId =
            int.parse(newId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 9));
      } catch (e) {
        newNumericId = DateTime.now().millisecondsSinceEpoch % 1000000000;
      }

      // Create a new message with updated path
      _messages[index] = MessageModel(
        id: newNumericId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sentAt: message.sentAt,
        isSeen: message.isSeen,
        content: message.content,
        filePath: serverFilePath,
        isOptimistic: false,
      );
      emit(MessageUpdatedState(_messages[index]));
    }
  }

  void _cleanupUpload(String clientMessageId) {
    _pendingUploads.remove(clientMessageId);
    _fileUploadProgress.remove(clientMessageId);
  }

  Future<void> cancelUpload(String clientMessageId) async {
    _cleanupUpload(clientMessageId);
    emit(const RealTimeChatInitial());
  }

  Future<void> reconnectSignalR() async {
    try {
      emit(const RealTimeChatLoading());
      _reconnectAttempts = 0;
      await _signalRService.initialize(userId: _senderId);
      emit(ConnectionStatusChanged(_signalRService.isConnected));

      if (_signalRService.isConnected) {
        emit(const RealTimeChatInitial());
      } else {
        emit(const RealTimeChatFailure(
            "Failed to reconnect. Please try again."));
      }
    } catch (e) {
      emit(RealTimeChatFailure("Reconnection error: ${e.toString()}"));
    }
  }

  Timer? _heartbeatTimer;

  void startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkConnectionHealth();
    });
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> checkConnectionHealth() async {
    if (!_signalRService.isConnected && !_isReconnecting) {
      _attemptReconnection();
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectionStatusSubscription?.cancel();
    _uploadProgressSubscription?.cancel();
    stopHeartbeat();

    messageController.dispose();
    scrollController.dispose();
    return super.close();
  }
}
