import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class MessageCubit extends Cubit<MessageState> {
  final DioConsumer dioConsumer;
  MessageCubit({required this.dioConsumer}) : super(MessageInitial());

  Future<void> getMyChat(String accessToken) async {
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
      final chats = ListChatModel.fromJson(response);
      emit(ChatSuccess(chats: chats));
    } on DioException catch (e) {
      String errorMessage = handleError(e);
      emit(MessageFailure(errorMessage));
    } catch (e) {
      emit(MessageFailure("An unexpected error occurred: $e"));
    }
  }

  Future<void> getMessages({
    required String userId,
    required String dateTime,
    required String pageSize,
    required String dateFilter,
    required String accessToken,
    required String receiverName,
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
      ));
    } on DioException catch (e) {
      String errorMessage = handleError(e);
      emit(MessageFailure(errorMessage));
    } catch (e) {
      emit(MessageFailure("An unexpected error occurred: $e"));
    }
  }
}
