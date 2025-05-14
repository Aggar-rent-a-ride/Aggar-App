import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/pick_date_of_birth_theme.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit() : super(const PersonalChatInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  // Search related controllers and flags
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool dateSelected = false;
  
  // Message highlighting
  String? highlightedMessageId;
  List<String> searchResultMessageIds = [];
  int currentHighlightIndex = -1;
  
  // Scroll control
  ScrollController scrollController = ScrollController();
  Map<String, GlobalKey> messageKeys = {};

  // Messages data
  List<MessageModel> _messages = [];
  int? _receiverId = 0;

  // Getters
  List<MessageModel> get messages => _messages;
  int? get receiverId => _receiverId;

  // Initialize from message state
  void initializeFromMessageState(MessageState state) {
    if (state is MessageSuccess && state.userId != null) {
      _receiverId = state.userId;
      print('Receiver ID initialized from MessageState: $_receiverId');

      if (state.messages != null && state.messages!.data.isNotEmpty) {
        setMessages(state.messages!.data);
      }
    }
  }

  // Set messages
  void setMessages(List<MessageModel> messageList) {
    _messages = List<MessageModel>.from(messageList);
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });
  }

  // Scroll to bottom
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Set receiver ID
  void setReceiverId(int id) {
    _receiverId = id;
    print('Receiver ID set to: $_receiverId');
  }

  // Clear all highlights
  void clearHighlights() {
    highlightedMessageId = null;
    emit(state);
  }

  // Highlight a specific message
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

  // Go to next search result
  void goToNextSearchResult() {
    if (searchResultMessageIds.isEmpty) return;

    currentHighlightIndex =
        (currentHighlightIndex + 1) % searchResultMessageIds.length;
    final nextMessageId = searchResultMessageIds[currentHighlightIndex];
    highlightedMessageId = nextMessageId;
    scrollToMessage(nextMessageId);
    emit(MessageHighlightedState(nextMessageId));
  }

  // Go to previous search result
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

  // Toggle search mode
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

  // Update search query
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

  // Filter messages
  Future<void> filterMessages(String accessToken) async {
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

  // Scroll to specific message
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

  // Select date for filtering
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

  // Clear search
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

  // Mark messages as seen
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

  @override
  Future<void> close() {
    searchController.dispose();
    dateController.dispose();
    scrollController.dispose();
    return super.close();
  }
}