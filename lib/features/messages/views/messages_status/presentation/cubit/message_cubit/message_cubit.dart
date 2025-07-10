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
  Timer? _pollingTimer;
  String? _accessToken;
  bool _isViewActive = false;
  ListChatModel? _cachedChats;

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreChats = true;
  bool _isLoadingMore = false;

  MessageCubit({required this.dioConsumer}) : super(MessageInitial()) {
    _loadCachedChats();
  }

  void startPolling(String accessToken, {required bool isViewActive}) {
    _accessToken = accessToken;
    _isViewActive = isViewActive;

    // Show cached data immediately if available
    if (_cachedChats != null) {
      emit(ChatSuccess(chats: _cachedChats!));
    }

    // Fetch fresh data
    getMyChat(accessToken);

    // Start polling for updates
    _pollingTimer?.cancel();
    if (_isViewActive) {
      _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_accessToken != null && _isViewActive) {
          _checkForNewMessages(_accessToken!);
        }
      });
    }
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isViewActive = false;
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
      if (_cachedChats == null || _hasNewMessages(_cachedChats!, newChats)) {
        _cachedChats = newChats;
        await _cacheChats(newChats);
        emit(ChatSuccess(chats: newChats));
      }
    } catch (e) {
      print("Error checking for new messages: $e");
      // Don't emit error to keep showing cached data
    }
  }

  Future<void> getMyChat(String accessToken, {bool loadMore = false}) async {
    if (_isLoadingMore) return;

    try {
      if (loadMore) {
        if (!_hasMoreChats) return;
        _isLoadingMore = true;
        _currentPage++;
        emit(ChatsLoadingMore(chats: _cachedChats!));
      } else {
        _currentPage = 1;
        _hasMoreChats = true;
        // Only show loading if no cached data
        if (_cachedChats == null) {
          emit(ChatsLoading());
        }
      }

      final response = await dioConsumer.get(
        "${EndPoint.getMyChat}?page=$_currentPage&pageSize=$_pageSize",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response == null) {
        if (_cachedChats == null && !loadMore) {
          emit(ChatsFailure("No response received from server."));
        }
        if (loadMore) {
          _currentPage--;
          _isLoadingMore = false;
        }
        return;
      }

      final newChats = ListChatModel.fromJson(response);
      _hasMoreChats = newChats.data.length == _pageSize;

      if (loadMore) {
        // Append new chats to existing ones
        final updatedChats = ListChatModel(
          data: [...(_cachedChats?.data ?? []), ...newChats.data],
        );
        _cachedChats = updatedChats;
        await _cacheChats(updatedChats);
        emit(ChatSuccess(chats: updatedChats));
        _isLoadingMore = false;
      } else {
        _cachedChats = newChats;
        await _cacheChats(newChats);
        emit(ChatSuccess(chats: newChats));
      }
    } catch (e) {
      if (_cachedChats == null && !loadMore) {
        emit(MessageFailure("Failed to fetch chats: $e"));
      } else if (loadMore) {
        _currentPage--;
        _isLoadingMore = false;
        emit(MessageFailure("Failed to load more chats: $e"));
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
      _cachedChats = null;
      _currentPage = 1;
      _hasMoreChats = true;
      emit(MessageInitial());
    } catch (e) {
      emit(MessageFailure("Failed to clear cache: $e"));
    }
  }

  bool _hasNewMessages(ListChatModel oldChats, ListChatModel newChats) {
    if (oldChats.data.length != newChats.data.length) return true;

    for (int i = 0; i < oldChats.data.length; i++) {
      final oldChat = oldChats.data[i];
      final newChat = newChats.data[i];

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
    return super.close();
  }
}
