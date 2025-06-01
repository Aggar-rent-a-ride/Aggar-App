import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/core/services/signalr_service_component.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
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
  RealTimeChatCubit(this.messageCubit) : super(const RealTimeChatInitial()) {
    _initServices();
  }

  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final SignalRService _signalRService = SignalRService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TextEditingController messageController = TextEditingController();
  final MessageCubit messageCubit;

  ScrollController scrollController = ScrollController();

  bool _isSendingMessage = false;
  bool _isUploadingFile = false;
  bool _canLoadMore = true;
  final int _pageSize = 20;
  String? _lastDateTime;
  final Map<String, double> _fileUploadProgress = {};
  final Map<String, String> _pendingUploads = {};
  final Map<String, PendingMessage> _pendingMessages = {};
  final Set<int> _processedServerMessageIds = {};
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  List<MessageModel> _messages = [];
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionStatusSubscription;
  StreamSubscription? _uploadProgressSubscription;
  StreamSubscription? _messageCubitSubscription;

  int? _receiverId;
  int _senderId = 0;
  bool get isUploadingFile => _isUploadingFile;
  bool get isConnected => _signalRService.isConnected;
  bool get canLoadMore => _canLoadMore;
  Map<String, double> get fileUploadProgress => _fileUploadProgress;
  Map<String, String> get pendingUploads => _pendingUploads;
  List<MessageModel> get messages => _messages;
  int get senderId => _senderId;
  int? get receiverId => _receiverId;

  Future<void> _initServices() async {
    await initializeSenderId();

    _messageSubscription = _signalRService.onMessageReceived.listen((message) {
      print(
          "📩 RAW MESSAGE RECEIVED: ${message.content} from ${message.senderId}");
      _handleIncomingMessage(message);
    });

    _connectionStatusSubscription =
        _signalRService.onConnectionChange.listen((isConnected) {
      print("🔗 Connection status changed: $isConnected");
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

    _messageCubitSubscription = messageCubit.stream.listen((state) {
      if (state is MessageSuccess) {
        final newMessages = state.messages!.data;
        if (newMessages.isEmpty) {
          _canLoadMore = false;
          emit(const MessagesLoaded());
          emit(const RealTimeChatInitial());
          return;
        }

        final existingMessageIds = _messages.map((m) => m.id).toSet();
        final filteredNewMessages = newMessages
            .where((m) => !existingMessageIds.contains(m.id))
            .toList();

        if (filteredNewMessages.isEmpty) {
          _canLoadMore = false;
          emit(const MessagesLoaded());
          emit(const RealTimeChatInitial());
          return;
        }

        _messages.addAll(filteredNewMessages);
        _messages.sort((a, b) =>
            DateTime.parse(b.sentAt).compareTo(DateTime.parse(a.sentAt)));
        _lastDateTime = _messages.last.sentAt;
        _processedServerMessageIds.addAll(filteredNewMessages.map((m) => m.id));
        emit(const MessagesLoaded());
        emit(const RealTimeChatInitial());
      } else if (state is MessageFailure) {
        emit(RealTimeChatFailure(
            "Failed to load more messages: ${state.errorMessage}"));
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
        "📨 PROCESSING MESSAGE: ${message.content} from ${message.senderId} to ${message.receiverId} with ID: ${message.id}");
    print(
        "📨 Current conversation: senderId=$_senderId, receiverId=$_receiverId");

    bool isForCurrentConversation = false;

    if (_receiverId != null && _senderId != 0) {
      bool isIncoming =
          (message.senderId == _receiverId && message.receiverId == _senderId);
      bool isOutgoing =
          (message.senderId == _senderId && message.receiverId == _receiverId);

      isForCurrentConversation = isIncoming || isOutgoing;

      print(
          "📨 CONVERSATION CHECK: isIncoming=$isIncoming, isOutgoing=$isOutgoing");
    }

    if (!isForCurrentConversation) {
      print("❌ Message not for current conversation - IGNORING");
      return;
    }

    if (message.id > 0 && _processedServerMessageIds.contains(message.id)) {
      print("⚠️ Duplicate message ID ${message.id}, ignoring");
      return;
    }

    if (message.id > 0) {
      _processedServerMessageIds.add(message.id);
    }

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

    if (message.senderId == _senderId) {
      _handleOptimisticMessageReplacement(newMessage);
    } else {
      _addIncomingMessage(newMessage);
    }

    _scrollToBottomImmediate();
  }

  void _addIncomingMessage(MessageModel message) {
    final existingIndex = _messages.indexWhere((m) =>
        m.id == message.id &&
        !m.isOptimistic &&
        m.senderId == message.senderId &&
        m.receiverId == message.receiverId);

    if (existingIndex == -1) {
      _addNewMessage(message);
    }
  }

  void _addNewMessage(MessageModel message) {
    int insertIndex = 0;
    final messageTime = DateTime.parse(message.sentAt);

    for (int i = 0; i < _messages.length; i++) {
      final existingTime = DateTime.parse(_messages[i].sentAt);
      if (messageTime.isAfter(existingTime)) {
        insertIndex = i;
        break;
      }
      insertIndex = i + 1;
    }

    _messages.insert(insertIndex, message);
    emit(MessageAddedState(message));

    Future.delayed(const Duration(milliseconds: 50), () {
      if (!isClosed) {
        emit(const RealTimeChatInitial());
      }
    });
  }

  void _handleOptimisticMessageReplacement(MessageModel serverMessage) {
    String? matchingClientId;
    PendingMessage? matchingPending;

    for (var entry in _pendingMessages.entries) {
      final pending = entry.value;
      if (_messagesMatch(pending.message, serverMessage)) {
        matchingClientId = entry.key;
        matchingPending = pending;
        break;
      }
    }

    if (matchingPending != null && matchingClientId != null) {
      final index = _messages.indexWhere(
          (m) => m.id == matchingPending!.message.id && m.isOptimistic);

      if (index != -1) {
        _messages[index] = serverMessage;
        _pendingMessages.remove(matchingClientId);
        emit(MessageUpdatedState(serverMessage));
      } else {
        final existingIndex = _messages
            .indexWhere((m) => m.id == serverMessage.id && !m.isOptimistic);

        if (existingIndex == -1) {
          _addNewMessage(serverMessage);
        }
        _pendingMessages.remove(matchingClientId);
      }
    } else {
      final existingIndex = _messages
          .indexWhere((m) => m.id == serverMessage.id && !m.isOptimistic);

      if (existingIndex == -1) {
        _addNewMessage(serverMessage);
      }
    }
  }

  bool _messagesMatch(MessageModel msg1, MessageModel msg2) {
    bool basicMatch = msg1.senderId == msg2.senderId &&
        msg1.receiverId == msg2.receiverId &&
        msg1.content == msg2.content &&
        msg1.filePath == msg2.filePath;

    if (!basicMatch) return false;

    return _timesMatch(msg1.sentAt, msg2.sentAt);
  }

  bool _timesMatch(String time1, String time2) {
    try {
      final dt1 = DateTime.parse(time1);
      final dt2 = DateTime.parse(time2);
      return dt1.difference(dt2).abs().inSeconds <= 10;
    } catch (e) {
      return time1 == time2;
    }
  }

  void setMessages(List<MessageModel> messageList) {
    _messages = List<MessageModel>.from(messageList);
    _pendingMessages.clear();
    _processedServerMessageIds.clear();

    for (var message in _messages) {
      if (!message.isOptimistic) {
        _processedServerMessageIds.add(message.id);
      }
    }

    // Sort messages to ensure oldest is last
    _messages.sort(
        (a, b) => DateTime.parse(b.sentAt).compareTo(DateTime.parse(a.sentAt)));
    _lastDateTime = _messages.isNotEmpty ? _messages.last.sentAt : null;
    print(
        "📅 Set _lastDateTime to: $_lastDateTime (messages: ${_messages.length})");
    _canLoadMore = true; // Reset canLoadMore
    _scrollToBottomImmediate();
  }

  void _scrollToBottomImmediate() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
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
    _pendingMessages.clear();
    _processedServerMessageIds.clear();
    _canLoadMore = true;
    _lastDateTime = null;
    print('🎯 Receiver ID set to: $_receiverId');
    _ensureConnected();
  }

  Future<bool> _ensureConnected() async {
    if (!_signalRService.isConnected) {
      try {
        print("🔌 Connecting to SignalR...");
        emit(const RealTimeChatLoading());

        await _signalRService.initialize(userId: _senderId);

        final isConnected = _signalRService.isConnected;
        emit(ConnectionStatusChanged(isConnected));

        if (isConnected) {
          print("✅ Connected to SignalR successfully");
          emit(const RealTimeChatInitial());
          startHeartbeat();
        } else {
          print("❌ Failed to connect to SignalR");
          emit(const RealTimeChatFailure("Failed to connect to chat server"));
        }

        return isConnected;
      } catch (e) {
        print('❌ Failed to connect to SignalR: $e');
        emit(RealTimeChatFailure("Connection error: ${e.toString()}"));
        return false;
      }
    }
    return true;
  }

  Future<void> initializeSenderId() async {
    try {
      final userIdStr = await _secureStorage.read(key: 'userId');
      int parsedId = 0;

      if (userIdStr != null && userIdStr.isNotEmpty) {
        parsedId = int.parse(userIdStr);
      }

      if (parsedId == 0) {
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
            }
          }
        }
      }

      _senderId = parsedId;
      print('👤 Sender ID: $_senderId');
      emit(SenderIdInitialized(_senderId));
    } catch (e) {
      _senderId = 0;
      emit(SenderIdInitialized(_senderId));
    }
  }

  Future<void> loadMoreMessages({
    required String userId,
    required String receiverName,
    required String accessToken,
  }) async {
    if (!_canLoadMore) {
      return;
    }
    if (_lastDateTime == null && _messages.isNotEmpty) {
      _lastDateTime = _messages.last.sentAt;
    }
    try {
      emit(const MessagesLoading());
      await messageCubit.getMessages(
        userId: userId,
        dateTime: _lastDateTime ?? DateTime.now().toIso8601String(),
        pageSize: _pageSize.toString(),
        dateFilter: '0',
        accessToken: accessToken,
        receiverName: receiverName,
      );
    } catch (e) {
      emit(RealTimeChatFailure("Failed to load messages: ${e.toString()}"));
    }
  }

  Future<void> sendMessage([String? accessToken]) async {
    if (_receiverId == null) {
      emit(const RealTimeChatFailure("Receiver ID is not set"));
      return;
    }

    if (messageController.text.trim().isEmpty || _isSendingMessage) {
      print("🚫 Message empty or sending in progress");
      return;
    }

    _isSendingMessage = true;
    final messageContent = messageController.text.trim();
    messageController.clear();

    final clientMessageId = const Uuid().v4();

    try {
      print("📤 Sending message: $messageContent");
      final optimisticMessage =
          _addOptimisticMessage(clientMessageId, messageContent);

      _pendingMessages[clientMessageId] = PendingMessage(
        clientId: clientMessageId,
        message: optimisticMessage,
        timestamp: DateTime.now(),
      );

      final isConnected = await _ensureConnected();
      if (!isConnected) {
        _removeOptimisticMessage(clientMessageId);
        emit(const RealTimeChatFailure("Not connected to chat server"));
        return;
      }

      await _signalRService.sendMessage(
        clientMessageId: clientMessageId,
        receiverId: _receiverId!,
        content: messageContent,
      );

      emit(MessageSentSuccessfully(clientMessageId));
      print("✅ Message sent successfully with clientId: $clientMessageId");
    } catch (e) {
      print("❌ Error sending message: $e");
      _removeOptimisticMessage(clientMessageId);
      emit(RealTimeChatFailure("Failed to send message: ${e.toString()}"));
    } finally {
      _isSendingMessage = false;
    }
  }

  MessageModel _addOptimisticMessage(String clientMessageId, String content) {
    final now = DateTime.now().toIso8601String();
    final tempId = -DateTime.now().millisecondsSinceEpoch;

    final newMessage = MessageModel(
      id: tempId,
      senderId: _senderId,
      receiverId: _receiverId!,
      sentAt: now,
      isSeen: false,
      content: content,
      filePath: null,
      isOptimistic: true,
    );

    _messages.insert(0, newMessage);
    emit(MessageAddedState(newMessage));
    _scrollToBottomImmediate();

    return newMessage;
  }

  void _removeOptimisticMessage(String clientMessageId) {
    if (_pendingMessages.containsKey(clientMessageId)) {
      final pendingMessage = _pendingMessages[clientMessageId]!.message;
      _messages.removeWhere(
          (msg) => msg.id == pendingMessage.id && msg.isOptimistic);
      _pendingMessages.remove(clientMessageId);
      emit(const RealTimeChatInitial());
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

          await sendFile(fileName, bytes, fileName, fileExtension);
        } else if (file.bytes != null) {
          final bytes = file.bytes!;
          final fileName = file.name;
          final fileExtension = path.extension(fileName).replaceFirst('.', '');

          await sendFile(fileName, bytes, fileName, fileExtension);
        } else {
          emit(const RealTimeChatFailure("Could not read file"));
        }
      }
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
      _updateFileMessage(clientMessageId, serverFilePath);

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
    final tempId = -DateTime.now().millisecondsSinceEpoch;

    final newMessage = MessageModel(
      id: tempId,
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

  void _updateFileMessage(String clientMessageId, String serverFilePath) {
    final index = _messages.indexWhere((msg) =>
        msg.filePath != null &&
        msg.filePath!.contains(clientMessageId) &&
        msg.isOptimistic == true);

    if (index != -1) {
      final message = _messages[index];
      _messages[index] = MessageModel(
        id: message.id,
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
    _messageCubitSubscription?.cancel();
    stopHeartbeat();

    messageController.dispose();
    scrollController.dispose();
    return super.close();
  }
}

class PendingMessage {
  final String clientId;
  final MessageModel message;
  final DateTime timestamp;

  PendingMessage({
    required this.clientId,
    required this.message,
    required this.timestamp,
  });
}
