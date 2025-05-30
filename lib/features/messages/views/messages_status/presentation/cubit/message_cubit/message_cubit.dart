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
      StreamController.broadcast();
  Stream<ListChatModel?> get chatStream => _chatStreamController.stream;
  Timer? _pollingTimer;
  String? _accessToken;
  bool _isViewActive = false;
  ListChatModel? _cachedChats;

  MessageCubit({required this.dioConsumer}) : super(MessageInitial()) {
    _loadCachedChats();
  }
  ListChatModel? get initialChats => _cachedChats;

  void startPolling(String accessToken, {required bool isViewActive}) {
    _accessToken = accessToken;
    _isViewActive = isViewActive;

    _pollingTimer?.cancel();

    if (_isViewActive) {
      _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_accessToken != null && _isViewActive) {
          getMyChat(_accessToken!);
        }
      });
    }
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isViewActive = false;
  }

  Future<void> _loadCachedChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedChats = prefs.getString('cached_chats');
      if (cachedChats != null) {
        _cachedChats = ListChatModel.fromJson(jsonDecode(cachedChats));
        emit(ChatSuccess(chats: _cachedChats!));
        _chatStreamController.add(_cachedChats);
      } else {
        _cachedChats = null;
        _chatStreamController.add(null);
      }
    } catch (e) {
      emit(MessageFailure("Failed to load cached chats: $e"));
      _chatStreamController.addError("Failed to load cached chats: $e");
    }
  }

  Future<void> _cacheChats(ListChatModel chats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_chats', jsonEncode(chats.toJson()));
      _cachedChats = chats; // Update local cache
    } catch (e) {
      emit(MessageFailure("Failed to cache chats: $e"));
    }
  }

  Future<bool> _hasChatsChanged(ListChatModel newChats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedChats = prefs.getString('cached_chats');
      if (cachedChats == null) return true;

      final oldChats = ListChatModel.fromJson(jsonDecode(cachedChats));
      if (oldChats.data.length != newChats.data.length) return true;

      for (int i = 0; i < oldChats.data.length; i++) {
        final oldChat = oldChats.data[i];
        final newChat = newChats.data[i];
        if (oldChat.lastMessage.sentAt != newChat.lastMessage.sentAt ||
            oldChat.unseenMessageIds.length !=
                newChat.unseenMessageIds.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      emit(MessageFailure("Error comparing chats: $e"));
      return true;
    }
  }

  Future<void> getMyChat(String accessToken) async {
    try {
      if (_cachedChats == null) {
        emit(ChatsLoading());
      }

      final response = await dioConsumer.get(
        EndPoint.getMyChat,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response == null) {
        emit(MessageFailure("No response received from server."));
        _chatStreamController.addError("No response received from server.");
        return;
      }
      final chats = ListChatModel.fromJson(response);
      if (await _hasChatsChanged(chats)) {
        await _cacheChats(chats);
        emit(ChatSuccess(chats: chats));
        _chatStreamController.add(chats);
      } else {
        if (_cachedChats != null) {
          emit(ChatSuccess(chats: _cachedChats!));
          _chatStreamController.add(_cachedChats);
        }
      }
    } on DioException catch (e) {
      String errorMessage = handleError(e);
      emit(MessageFailure(errorMessage));
      _chatStreamController.addError(errorMessage);
    } catch (e) {
      emit(MessageFailure("An unexpected error occurred: $e"));
      _chatStreamController.addError("An unexpected error occurred: $e");
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
      await Future.delayed(const Duration(seconds: 1));
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
      emit(MessageInitial());
      _chatStreamController.add(null);
    } catch (e) {
      emit(MessageFailure("Failed to clear cache: $e"));
      _chatStreamController.addError("Failed to clear cache: $e");
    }
  }

  @override
  Future<void> close() {
    stopPolling();
    _chatStreamController.close();
    return super.close();
  }
}
