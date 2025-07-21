import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:equatable/equatable.dart';

abstract class PersonalChatState extends Equatable {
  const PersonalChatState();

  @override
  List<Object?> get props => [];
}

class PersonalChatInitial extends PersonalChatState {
  const PersonalChatInitial();
}

class PersonalChatSearch extends PersonalChatState {
  const PersonalChatSearch();
}

class PersonalChatLoading extends PersonalChatState {
  const PersonalChatLoading();
}

class PersonalChatSuccess extends PersonalChatState {
  final ListMessageModel messages;
  const PersonalChatSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class PersonalChatFailure extends PersonalChatState {
  final String error;
  const PersonalChatFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class MessageHighlightedState extends PersonalChatState {
  final String messageId;
  const MessageHighlightedState(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
