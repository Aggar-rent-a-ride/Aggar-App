import 'dart:convert';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/pick_date_of_birth_theme.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit() : super(const PersonalChatInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final SignalRService _signalRService = SignalRService();
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool dateSelected = false;
  List<String> highlightedMessageIds = [];
  ScrollController scrollController = ScrollController();
  Map<String, GlobalKey> messageKeys = {};
  bool _isSendingMessage = false;
  // NEED TO FIX
  int receiverId = 11;

  void setReceiverId(int id) {
    receiverId = id;
  }

  void clearHighlights() {
    highlightedMessageIds = [];
    emit(state);
  }

  void toggleSearchMode() {
    if (state is PersonalChatSearch) {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
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
    try {
      emit(PersonalChatLoading());
      Map<String, dynamic> data = {
        ApiKey.filterMessagesSenderId: 11,
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
      highlightedMessageIds =
          messages.data.map((message) => message.id.toString()).toList();
      //  print("Highlighted Message IDs: $highlightedMessageIds");
      await Future.delayed(const Duration(milliseconds: 500));
      emit(PersonalChatSuccess(messages));
      if (highlightedMessageIds.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToMessage(highlightedMessageIds[0]);
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
          Future.delayed(const Duration(seconds: 2), () {
            clearHighlights();
          });
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

  Future<void> sendMessage(int receiverId, String accessToken) async {
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
        receiverId: receiverId,
        content: messageContent,
      );
    } catch (e) {
      emit(PersonalChatFailure("Failed to send message: ${e.toString()}"));
    } finally {
      _isSendingMessage = false;
    }
  }

  Future<void> sendFile(int receiverId, String filePath, List<int> fileBytes,
      String fileName, String fileExtension) async {
    if (_isSendingMessage) {
      return;
    }

    _isSendingMessage = true;

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

      // 1. Initiate upload
      final response = await _signalRService.initiateFileUpload(
        clientMessageId: clientMessageId,
        fileName: fileName,
        fileExtension: fileExtension,
      );

      // 2. Upload file in chunks
      const int chunkSize = 4096;
      for (int i = 0; i < fileBytes.length; i += chunkSize) {
        final end = (i + chunkSize < fileBytes.length)
            ? i + chunkSize
            : fileBytes.length;
        final chunk = fileBytes.sublist(i, end);
        final bytesBase64 = base64.encode(chunk);

        await _signalRService.uploadFileChunk(
          clientMessageId: clientMessageId,
          receiverId: receiverId,
          filePath: response.filePath,
          bytesBase64: bytesBase64,
          totalBytes: fileBytes.length,
        );
      }

      // 3. Finish upload
      await _signalRService.finishFileUpload(
        clientMessageId: clientMessageId,
        receiverId: receiverId,
        filePath: response.filePath,
        fileBytes: fileBytes,
      );
    } catch (e) {
      emit(PersonalChatFailure("Failed to send file: ${e.toString()}"));
    } finally {
      _isSendingMessage = false;
    }
  }
}
