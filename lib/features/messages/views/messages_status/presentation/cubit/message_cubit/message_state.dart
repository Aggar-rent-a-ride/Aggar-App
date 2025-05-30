import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';

sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageSuccess extends MessageState {
  final ListMessageModel? messages;
  final int? userId;
  final String receiverName;
  final String? reciverImg;

  MessageSuccess(
      {this.messages,
      this.userId,
      required this.receiverName,
      this.reciverImg});
}

final class ChatSuccess extends MessageState {
  final ListChatModel? chats;
  ChatSuccess({this.chats});
}

class ChatsLoaded extends MessageState {}

final class ChatsLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final String messageUrl;
  final String mimeType;

  MessageLoaded({required this.messageUrl, required this.mimeType});
}

final class MessageLoading extends MessageState {}

final class MessageFailure extends MessageState {
  final String errorMessage;

  MessageFailure(this.errorMessage);
}
