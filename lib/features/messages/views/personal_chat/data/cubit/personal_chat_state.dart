import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:equatable/equatable.dart';

abstract class PersonalChatState extends Equatable {
  const PersonalChatState();

  @override
  List<Object?> get props => [];
}

class PersonalChatInitial extends PersonalChatState {
  const PersonalChatInitial();
}

class PersonalChatSearch extends PersonalChatState {}

final class PersonalChatLoading extends PersonalChatState {}

final class PersonalChatSuccess extends PersonalChatState {
  final ListMessageModel messages;

  const PersonalChatSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

final class PersonalChatFailure extends PersonalChatState {
  final String error;

  const PersonalChatFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class MessageSentSuccessfully extends PersonalChatState {
  final String messageId;

  const MessageSentSuccessfully(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MessageAddedState extends PersonalChatState {
  final MessageModel message;

  const MessageAddedState(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageUpdatedState extends PersonalChatState {
  final MessageModel message;

  const MessageUpdatedState(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageHighlightedState extends PersonalChatState {
  final String messageId;

  const MessageHighlightedState(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class DateSelectedState extends PersonalChatState {
  final String date;

  const DateSelectedState(this.date);

  @override
  List<Object?> get props => [date];
}

class FileUploadInProgress extends PersonalChatState {
  final String clientMessageId;
  final String fileName;
  final double progress;

  const FileUploadInProgress(
      this.clientMessageId, this.fileName, this.progress);

  @override
  List<Object?> get props => [clientMessageId, fileName, progress];
}

class FileUploadComplete extends PersonalChatState {
  final String clientMessageId;
  final String fileName;

  const FileUploadComplete(this.clientMessageId, this.fileName);

  @override
  List<Object?> get props => [clientMessageId, fileName];
}

class FileUploadFailed extends PersonalChatState {
  final String clientMessageId;
  final String error;

  const FileUploadFailed(this.clientMessageId, this.error);

  @override
  List<Object?> get props => [clientMessageId, error];
}

class SenderIdInitialized extends PersonalChatState {
  final int senderId;

  const SenderIdInitialized(this.senderId);

  @override
  List<Object?> get props => [senderId];
}
