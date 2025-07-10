import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

// Chat-related states
class ChatsLoading extends MessageState {}

class ChatsLoadingMore extends MessageState {
  final ListChatModel chats;
  ChatsLoadingMore({required this.chats});
}

class ChatSuccess extends MessageState {
  final ListChatModel chats;
  ChatSuccess({required this.chats});
}

class ChatsFailure extends MessageState {
  final String errorMessage;
  ChatsFailure(this.errorMessage);
}

// Message-related states (for navigation)
class MessageLoading extends MessageState {}

class MessageSuccess extends MessageState {
  final ListMessageModel? messages;
  final int? userId;
  final String receiverName;
  final String? reciverImg;

  MessageSuccess({
    required this.messages,
    required this.userId,
    required this.receiverName,
    required this.reciverImg,
  });
}

class MessageFailure extends MessageState {
  final String errorMessage;
  MessageFailure(this.errorMessage);
}
