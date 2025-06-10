import 'dart:async';
import 'dart:convert';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageCubit extends Cubit<MessageState> {
  final DioConsumer dioConsumer;
  final StreamController<ListChatModel?> _chatStreamController =
      StreamController<ListChatModel?>.broadcast();
  Stream<ListChatModel?> get chatStream => _chatStreamController.stream;
  Timer? _pollingTimer;
  String? _accessToken;
  bool _isViewActive = false;
  ListChatModel? _cachedChats;
  DateTime? _lastCacheUpdate;

  MessageCubit({required this.dioConsumer}) : super(MessageInitial()) {
    _loadCachedChats();
  }
  ListChatModel? get initialChats => _cachedChats;

  void startPolling(String accessToken, {required bool isViewActive}) {
    _accessToken = accessToken;
    _isViewActive = isViewActive;

    // First, show cached data immediately if available
    if (_cachedChats != null) {
      emit(ChatSuccess(chats: _cachedChats));
      _chatStreamController.add(_cachedChats);
    }

    // Then fetch fresh data in the background
    _fetchInitialChats(accessToken);

    // Start polling for updates with a small delay to avoid race conditions
    _pollingTimer?.cancel();
    if (_isViewActive) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isViewActive) {
          _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
            if (_accessToken != null && _isViewActive) {
              _checkForNewMessages(_accessToken!);
            }
          });
        }
      });
    }
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isViewActive = false;
  }

  Future<void> _fetchInitialChats(String accessToken) async {
    try {
      final response = await dioConsumer.get(
        EndPoint.getMyChat,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response == null) return;

      final chats = ListChatModel.fromJson(response);
      _cachedChats = chats;
      await _cacheChats(chats);

      // Only emit if the data has changed
      if (_hasNewMessages(_cachedChats!, chats)) {
        emit(ChatSuccess(chats: chats));
        _chatStreamController.add(chats);
      }
    } catch (e) {
      print("Error fetching initial chats: $e");
      // Don't emit error to keep showing cached data
    }
  }

  Future<void> _checkForNewMessages(String accessToken) async {
    try {
      final response = await dioConsumer.get(
        EndPoint.getMyChat,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response == null) return;

      final newChats = ListChatModel.fromJson(response);

      // Only update if there are actual changes
      if (_cachedChats == null || _hasNewMessages(_cachedChats!, newChats)) {
        _cachedChats = newChats;
        await _cacheChats(newChats);
        emit(ChatSuccess(chats: newChats));
        _chatStreamController.add(newChats);
      }
    } catch (e) {
      print("Error checking for new messages: $e");
    }
  }

  Future<void> getMyChat(String accessToken) async {
    try {
      // Always fetch fresh data when explicitly requested
      final response = await dioConsumer.get(
        EndPoint.getMyChat,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response == null) {
        if (_cachedChats == null) {
          emit(MessageFailure("No response received from server."));
        }
        return;
      }

      final chats = ListChatModel.fromJson(response);
      _cachedChats = chats;
      await _cacheChats(chats);

      // Always emit new data when explicitly requested
      emit(ChatSuccess(chats: chats));
      _chatStreamController.add(chats);
    } catch (e) {
      if (_cachedChats == null) {
        emit(MessageFailure("Failed to fetch chats: $e"));
      }
    }
  }

  Future<void> _loadCachedChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedChats = prefs.getString('cached_chats');

      if (cachedChats != null) {
        _cachedChats = ListChatModel.fromJson(jsonDecode(cachedChats));
        emit(ChatSuccess(chats: _cachedChats!));
        _chatStreamController.add(_cachedChats);
      }
    } catch (e) {
      print("Error loading cached chats: $e");
    }
  }

  Future<void> _cacheChats(ListChatModel chats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_chats', jsonEncode(chats.toJson()));
    } catch (e) {
      print("Error caching chats: $e");
    }
  }

  Future<void> getMessages({
    required String userId,
    required String dateTime,
    required String pageSize,
    required String dateFilter,
    required String accessToken,
    required String receiverName,
    String? receiverImg,
  }) async {
    try {
      emit(MessageLoading());
      final response = await dioConsumer.get(
        "${EndPoint.getMessageBetween}?userId=$userId&dateTime=$dateTime&pageSize=$pageSize&dateFilter=$dateFilter",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response == null) {
        emit(MessageFailure("No response received from server."));
        return;
      }
      final ListMessageModel messages = ListMessageModel.fromJson(response);
      emit(MessageSuccess(
          messages: messages,
          userId: int.parse(userId),
          receiverName: receiverName,
          reciverImg: receiverImg));
    } on DioException catch (e) {
      String errorMessage = handleError(e);
      emit(MessageFailure(errorMessage));
    } catch (e) {
      emit(MessageFailure("An unexpected error occurred: $e"));
    }
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_chats');
      await prefs.remove('last_cache_update');
      _cachedChats = null;
      _lastCacheUpdate = null;
      emit(MessageInitial());
      _chatStreamController.add(null);
    } catch (e) {
      emit(MessageFailure("Failed to clear cache: $e"));
      _chatStreamController.addError("Failed to clear cache: $e");
    }
  }

  bool _hasNewMessages(ListChatModel oldChats, ListChatModel newChats) {
    if (oldChats.data.length != newChats.data.length) return true;

    for (int i = 0; i < oldChats.data.length; i++) {
      final oldChat = oldChats.data[i];
      final newChat = newChats.data[i];

      // Check for new messages, changes in unseen messages, or changes in last message
      if (oldChat.lastMessage.sentAt != newChat.lastMessage.sentAt ||
          oldChat.unseenMessageIds.length != newChat.unseenMessageIds.length ||
          oldChat.lastMessage.content != newChat.lastMessage.content ||
          oldChat.lastMessage.filePath != newChat.lastMessage.filePath) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> close() {
    stopPolling();
    if (!_chatStreamController.isClosed) {
      _chatStreamController.close();
    }
    return super.close();
  }
}
