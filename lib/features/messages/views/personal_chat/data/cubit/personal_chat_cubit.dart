import 'dart:convert';
import 'dart:io';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/pick_date_of_birth_theme.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit() : super(const PersonalChatInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final SignalRService _signalRService = SignalRService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool dateSelected = false;
  String? highlightedMessageId;
  List<String> searchResultMessageIds = [];
  int currentHighlightIndex = -1;
  ScrollController scrollController = ScrollController();
  Map<String, GlobalKey> messageKeys = {};
  bool _isSendingMessage = false;
  bool _isUploadingFile = false;
  final Map<String, double> _fileUploadProgress = {};
  final Map<String, String> _pendingUploads = {};

  List<MessageModel> _messages = [];

  int? _receiverId = 0;
  int _senderId = 0;

  bool get isUploadingFile => _isUploadingFile;
  Map<String, double> get fileUploadProgress => _fileUploadProgress;
  Map<String, String> get pendingUploads => _pendingUploads;
  List<MessageModel> get messages => _messages;
  int get senderId => _senderId;
  int? get receiverId => _receiverId;

  void initializeFromMessageState(MessageState state) {
    if (state is MessageSuccess && state.userId != null) {
      _receiverId = state.userId;
      print('Receiver ID initialized from MessageState: $_receiverId');

      if (state.messages != null && state.messages!.data.isNotEmpty) {
        setMessages(state.messages!.data);
      }
    }
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

  void setMessages(List<MessageModel> messageList) {
    _messages = List<MessageModel>.from(messageList);
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });
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
  }

  void clearHighlights() {
    highlightedMessageId = null;
    emit(state);
  }

  void highlightMessage(String messageId) {
    highlightedMessageId = messageId;
    emit(MessageHighlightedState(messageId));
    if (messageKeys.containsKey(messageId) &&
        messageKeys[messageId]!.currentContext != null) {
      Scrollable.ensureVisible(
        messageKeys[messageId]!.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
    }

    Future.delayed(const Duration(seconds: 2), () {
      highlightedMessageId = null;
    });
  }

  void goToNextSearchResult() {
    if (searchResultMessageIds.isEmpty) return;

    currentHighlightIndex =
        (currentHighlightIndex + 1) % searchResultMessageIds.length;
    final nextMessageId = searchResultMessageIds[currentHighlightIndex];
    highlightedMessageId = nextMessageId;
    scrollToMessage(nextMessageId);
    emit(MessageHighlightedState(nextMessageId));
  }

  void goToPreviousSearchResult() {
    if (searchResultMessageIds.isEmpty) return;

    currentHighlightIndex =
        (currentHighlightIndex - 1 + searchResultMessageIds.length) %
            searchResultMessageIds.length;
    final prevMessageId = searchResultMessageIds[currentHighlightIndex];
    highlightedMessageId = prevMessageId;
    scrollToMessage(prevMessageId);
    emit(MessageHighlightedState(prevMessageId));
  }

  void toggleSearchMode() {
    if (state is PersonalChatSearch) {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
        clearHighlights();
        searchResultMessageIds = [];
        currentHighlightIndex = -1;
        emit(const PersonalChatInitial());
      } else {
        emit(PersonalChatSearch());
      }
    } else {
      isSearchActive = true;
      emit(PersonalChatSearch());
    }
  }

  void updateSearchQuery(String query) {
    searchController.text = query;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );
    if (state is! PersonalChatSearch) {
      isSearchActive = true;
      emit(PersonalChatSearch());
    }
  }

  Future<void> filtterMessage(String accessToken) async {
    if (_receiverId == null) {
      emit(const PersonalChatFailure("Receiver ID is not set"));
      return;
    }
    try {
      emit(PersonalChatLoading());
      Map<String, dynamic> data = {
        ApiKey.filterMessagesSenderId: _receiverId,
        ApiKey.filterMsgPageNo: 1,
        ApiKey.filterMsgPageSize: 30,
      };
      if (dateSelected && dateController.text.isNotEmpty) {
        data[ApiKey.filterMsgDateTime] = dateController.text;
      } else if (searchController.text.isNotEmpty) {
        data[ApiKey.filterMsgSearchContent] = searchController.text;
      }
      final response = await dioConsumer.get(
        data: data,
        EndPoint.filterMessages,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print("API Response: $response");
      if (response == null) {
        emit(const PersonalChatFailure("No response received from server."));
        return;
      }
      final ListMessageModel messages = ListMessageModel.fromJson(response);
      searchResultMessageIds =
          messages.data.map((message) => message.id.toString()).toList();
      currentHighlightIndex = searchResultMessageIds.isEmpty ? -1 : 0;

      if (searchResultMessageIds.isNotEmpty) {
        highlightedMessageId = searchResultMessageIds[0];
      } else {
        highlightedMessageId = null;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      emit(PersonalChatSuccess(messages));

      if (highlightedMessageId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToMessage(highlightedMessageId!);
        });
      }
    } catch (e) {
      emit(PersonalChatFailure(e.toString()));
    }
  }

  void scrollToMessage(String messageId, {int retryCount = 0}) {
    const maxRetries = 5;
    const retryDelay = Duration(milliseconds: 500);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messageKeys.containsKey(messageId) &&
          messageKeys[messageId]!.currentContext != null) {
        try {
          final RenderObject renderObject =
              messageKeys[messageId]!.currentContext!.findRenderObject()!;
          final RenderAbstractViewport viewport =
              RenderAbstractViewport.of(renderObject);
          final RevealedOffset offset =
              viewport.getOffsetToReveal(renderObject, 0.5);
          scrollController.animateTo(
            offset.offset.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          if (searchResultMessageIds.length <= 1) {
            Future.delayed(const Duration(seconds: 2), () {
              clearHighlights();
            });
          }
        } catch (e) {
          if (retryCount < maxRetries) {
            Future.delayed(retryDelay, () {
              scrollToMessage(messageId, retryCount: retryCount + 1);
            });
          }
        }
      } else {
        if (retryCount < maxRetries) {
          double estimatedOffset =
              scrollController.position.pixels + (retryCount + 1) * 500.0;
          estimatedOffset = estimatedOffset.clamp(
              0.0, scrollController.position.maxScrollExtent);
          scrollController.animateTo(
            estimatedOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          Future.delayed(retryDelay, () {
            scrollToMessage(messageId, retryCount: retryCount + 1);
          });
        }
      }
    });
  }

  Future<void> selectDate(BuildContext context) async {
    searchController.clear();

    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return pickDateOfBirthTheme(context, child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      dateSelected = true;
      searchController.text = dateController.text;
      emit(DateSelectedState(dateController.text));
    }
  }

  void clearSearch() {
    isSearchActive = false;
    searchController.clear();
    dateController.clear();
    dateSelected = false;
    clearHighlights();
    searchResultMessageIds = [];
    currentHighlightIndex = -1;
    emit(const PersonalChatInitial());
  }

  @override
  Future<void> close() {
    searchController.dispose();
    messageController.dispose();
    dateController.dispose();
    scrollController.dispose();
    return super.close();
  }

  Future<void> markAsSeen(String accessToken, List<int> ids) async {
    try {
      emit(PersonalChatLoading());
      FormData formData = FormData();
      if (ids.isNotEmpty) {
        for (int i = 0; i < ids.length; i++) {
          formData.files.add(
            MapEntry(
              ApiKey.markAsSeenMsgId,
              MultipartFile.fromString(
                ids[i].toString(),
              ),
            ),
          );
        }
      }
      final response = await dioConsumer.put(
        EndPoint.markAsSeen,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        emit(const PersonalChatInitial());
      } else {
        emit(const PersonalChatFailure("Failed to mark messages as seen"));
      }
    } catch (e) {
      emit(PersonalChatFailure(
          "Failed to mark messages as seen : ${e.toString()}"));
    }
  }

  Future<void> sendMessage(String accessToken) async {
    if (_receiverId == null) {
      emit(const PersonalChatFailure("Receiver ID is not set"));
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

      if (!_signalRService.isConnected) {
        await _signalRService.initialize();
        if (!_signalRService.isConnected) {
          _removeMessage(tempId);
          emit(const PersonalChatFailure(
              "Failed to connect to chat server. Please try again."));
          _isSendingMessage = false;
          return;
        }
      }

      await _signalRService.sendMessage(
        clientMessageId: clientMessageId,
        receiverId: _receiverId!,
        content: messageContent,
      );
      _updateMessageId(tempId, clientMessageId);
      emit(MessageSentSuccessfully(clientMessageId));
      Future.delayed(const Duration(milliseconds: 100), () {
        emit(const PersonalChatInitial());
      });
    } catch (e) {
      print("Error sending message: $e");
      _removeMessage(tempId);
      emit(PersonalChatFailure("Failed to send message: ${e.toString()}"));
      Future.delayed(const Duration(milliseconds: 500), () {
        emit(const PersonalChatInitial());
      });
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
    Future.delayed(const Duration(milliseconds: 100), () {
      emit(const PersonalChatInitial());
    });
  }

  void _removeMessage(String tempId) {
    _messages.removeWhere((msg) => msg.id.toString() == tempId);
    emit(const PersonalChatInitial());
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
      Future.delayed(const Duration(milliseconds: 100), () {
        emit(const PersonalChatInitial());
      });
    }
  }

  Future<void> pickAndSendFile() async {
    print("pickAndSendFile called");
    if (_receiverId == null) {
      emit(const PersonalChatFailure("Receiver ID is not set"));
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt'
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.path != null) {
          final File fileObj = File(file.path!);
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
        }
      }
    } catch (e) {
      emit(PersonalChatFailure("Failed to pick file: ${e.toString()}"));
    }
  }

  Future<void> sendFile(String filePath, List<int> fileBytes, String fileName,
      String fileExtension) async {
        print(
        "sendFile called with fileName: $fileName, fileExtension: $fileExtension, fileBytes length: ${fileBytes.length}");
    if (_receiverId == null) {
      emit(const PersonalChatFailure("Receiver ID is not set"));
      return;
    }

    if (_isUploadingFile) {
      emit(const PersonalChatFailure("A file upload is already in progress"));
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
      if (!_signalRService.isConnected) {
        await _signalRService.initialize();
        if (!_signalRService.isConnected) {
          _removeMessage(tempId);
          emit(const PersonalChatFailure(
              "Failed to connect to chat server. Please try again."));
          _isUploadingFile = false;
          _cleanupUpload(clientMessageId);
          return;
        }
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

      final uploadProgressSubscription =
          _signalRService.onUploadProgress.listen((progress) {
        if (progress.clientMessageId == clientMessageId) {
          final progressPercent = progress.progressPercentage;
          _fileUploadProgress[clientMessageId] = progressPercent;
          emit(
              FileUploadInProgress(clientMessageId, fileName, progressPercent));
        }
      });

      const int chunkSize = 4096;
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
      }

      final checksum = sha256.convert(fileBytes).toString();
      await _signalRService.finishFileUpload(
        clientMessageId: clientMessageId,
        receiverId: _receiverId!,
        filePath: serverFilePath,
        fileBytes: fileBytes,
      );

      uploadProgressSubscription.cancel();
      _fileUploadProgress[clientMessageId] = 100.0;
      emit(FileUploadComplete(clientMessageId, fileName));
      _updateFileMessage(tempId, clientMessageId, serverFilePath);
      Future.delayed(const Duration(seconds: 2), () {
        _cleanupUpload(clientMessageId);
        emit(const PersonalChatInitial());
      });
    } catch (e) {
      _removeMessage(tempId);
      _cleanupUpload(clientMessageId);
      emit(PersonalChatFailure("Failed to upload file: ${e.toString()}"));
    }

    _isUploadingFile = false;
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
    Future.delayed(const Duration(milliseconds: 100), () {
      emit(const PersonalChatInitial());
    });
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
      Future.delayed(const Duration(milliseconds: 100), () {
        emit(const PersonalChatInitial());
      });
    }
  }

  void _cleanupUpload(String clientMessageId) {
    _pendingUploads.remove(clientMessageId);
    _fileUploadProgress.remove(clientMessageId);
  }

  Future<void> cancelUpload(String clientMessageId) async {
    _cleanupUpload(clientMessageId);
    emit(const PersonalChatInitial());
  }
}
