part of 'message_cubit.dart';

sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageSuccess extends MessageState {
  final ListMessageModel? messages;
  final ListChatModel? chats;
  MessageSuccess({this.messages, this.chats});
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
