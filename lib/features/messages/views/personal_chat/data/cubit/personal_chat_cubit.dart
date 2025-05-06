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
      if (userIdStr != null && userIdStr.isNotEmpty) {
        _senderId = int.parse(userIdStr);
        print('Sender ID initialized: $_senderId');
      } else {
        print('Warning: User ID not found in secure storage');
        _senderId = 0;
      }
    } catch (e) {
      print('Error retrieving sender ID: $e');
      _senderId = 0;
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

    try {
      final clientMessageId = const Uuid().v4();

      if (!_signalRService.isConnected) {
        await _signalRService.initialize();
        if (!_signalRService.isConnected) {
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
      _addLocalMessage(clientMessageId, messageContent);
    } catch (e) {
      emit(PersonalChatFailure("Failed to send message: ${e.toString()}"));
    } finally {
      _isSendingMessage = false;
    }
  }

  void _addLocalMessage(String clientMessageId, String content) {
    final now = DateTime.now().toIso8601String();
    final newMessage = MessageModel(
      id: int.parse(
          DateTime.now().millisecondsSinceEpoch.toString().substring(0, 9)),
      senderId: _senderId,
      receiverId: _receiverId!,
      sentAt: now,
      isSeen: false,
      content: content,
      filePath: null,
    );
    _messages.insert(0, newMessage);
    emit(const PersonalChatInitial());
  }

  Future<void> pickAndSendFile() async {
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

    _pendingUploads[clientMessageId] = fileName;
    _fileUploadProgress[clientMessageId] = 0.0;
    emit(FileUploadInProgress(clientMessageId, fileName, 0.0));
    try {
      if (!_signalRService.isConnected) {
        await _signalRService.initialize();
        if (!_signalRService.isConnected) {
          emit(const PersonalChatFailure(
              "Failed to connect to chat server. Please try again."));
          _isUploadingFile = false;
          _cleanupUpload(clientMessageId);
          return;
        }
      }
      print("Starting file upload process for $fileName ($fileExtension)");

      try {
        print("Initiating file upload with clientMessageId: $clientMessageId");
        final response = await _signalRService.initiateFileUpload(
          clientMessageId: clientMessageId,
          fileName: fileName,
          fileExtension: fileExtension,
        );

        final serverFilePath = response.filePath;
        print("Server file path received: $serverFilePath");

        if (serverFilePath.isEmpty) {
          throw Exception("Server returned empty file path");
        }

        final uploadProgressSubscription =
            _signalRService.onUploadProgress.listen((progress) {
          if (progress.clientMessageId == clientMessageId) {
            final progressPercent = progress.progressPercentage;
            _fileUploadProgress[clientMessageId] = progressPercent;
            emit(FileUploadInProgress(
                clientMessageId, fileName, progressPercent));
          }
        });
        const int chunkSize = 4096;
        for (int i = 0; i < fileBytes.length; i += chunkSize) {
          final end = (i + chunkSize < fileBytes.length)
              ? i + chunkSize
              : fileBytes.length;
          final chunk = fileBytes.sublist(i, end);
          final bytesBase64 = base64.encode(chunk);

          print(
              "Uploading chunk ${i ~/ chunkSize + 1}/${(fileBytes.length / chunkSize).ceil()}");
          await _signalRService.uploadFileChunk(
            clientMessageId: clientMessageId,
            receiverId: _receiverId!,
            filePath: serverFilePath,
            bytesBase64: bytesBase64,
            totalBytes: fileBytes.length,
          );
        }

        print("Calculating checksum and finishing upload");
        final checksum = sha256.convert(fileBytes).toString();
        print("Checksum generated: $checksum");

        await _signalRService.finishFileUpload(
          clientMessageId: clientMessageId,
          receiverId: _receiverId!,
          filePath: serverFilePath,
          fileBytes: fileBytes,
        );

        uploadProgressSubscription.cancel();
        _fileUploadProgress[clientMessageId] = 100.0;
        emit(FileUploadComplete(clientMessageId, fileName));
        _addLocalFileMessage(clientMessageId, serverFilePath, fileName);
        Future.delayed(const Duration(seconds: 2), () {
          _cleanupUpload(clientMessageId);
          emit(const PersonalChatInitial()); // Force UI refresh
        });
      } catch (e) {
        print("Error during file upload: $e");
        if (e.toString().contains("Server error:")) {
          final errorMessage =
              e.toString().replaceAll("Exception: Server error: ", "");
          emit(PersonalChatFailure("Server error: $errorMessage"));
        } else if (e.toString().contains("FormatException")) {
          emit(const PersonalChatFailure(
              "Invalid response from server. Please try again."));
        } else {
          emit(PersonalChatFailure(
              "Failed during file upload: ${e.toString()}"));
        }
        _cleanupUpload(clientMessageId);
      }
    } catch (e) {
      _cleanupUpload(clientMessageId);
      emit(PersonalChatFailure("Failed to upload file: ${e.toString()}"));
    } finally {
      _isUploadingFile = false;
    }
  }

  void _addLocalFileMessage(
      String clientMessageId, String filePath, String fileName) {
    if (_receiverId == null) return;
    final now = DateTime.now().toIso8601String();
    final newMessage = MessageModel(
      id: int.parse(
          DateTime.now().millisecondsSinceEpoch.toString().substring(0, 9)),
      senderId: _senderId,
      receiverId: _receiverId!,
      sentAt: now,
      isSeen: false,
      content: null,
      filePath: filePath,
    );
    _messages.insert(0, newMessage);
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
