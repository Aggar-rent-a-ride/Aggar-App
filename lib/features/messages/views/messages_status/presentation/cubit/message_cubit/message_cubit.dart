import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final DioConsumer dioConsumer;
  ListChatModel? _cachedChats;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  MessageCubit({required this.dioConsumer}) : super(MessageInitial());

  bool get hasValidCache {
    return _cachedChats != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  Future<void> getMyChat(String accessToken) async {
    if (hasValidCache) {
      emit(ChatSuccess(chats: _cachedChats));
      return;
    }
    try {
      emit(ChatsLoading());
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
        return;
      }
      _cachedChats = ListChatModel.fromJson(response);
      _lastFetchTime = DateTime.now();
      emit(ChatSuccess(chats: _cachedChats));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  void invalidateCache() {
    _cachedChats = null;
    _lastFetchTime = null;
  }

  Future<void> getMessages(String userId, String dateTime, String pageSize,
      String dateFilter, String accessToken) async {
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
      await Future.delayed(const Duration(seconds: 2));
      // Store the userId for later use
      emit(MessageSuccess(messages: messages, userId: int.parse(userId)));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }
}
