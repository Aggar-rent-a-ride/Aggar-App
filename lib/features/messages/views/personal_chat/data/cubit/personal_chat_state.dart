import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class PersonalChatState {
  const PersonalChatState();
}

final class PersonalChatInitial extends PersonalChatState {
  const PersonalChatInitial();
}

class PersonalChatSearch extends PersonalChatState {}

final class PersonalChatLoading extends PersonalChatState {}

final class PersonalChatSuccess extends PersonalChatState {
  final ListMessageModel messages;

  const PersonalChatSuccess(this.messages);
}

final class PersonalChatFailure extends PersonalChatState {
  final String error;

  const PersonalChatFailure(this.error);
}

class MessageHighlightedState extends PersonalChatState {
  final String messageId;

  const MessageHighlightedState(this.messageId);
}

class DateSelectedState extends PersonalChatState {
  final String selectedDate;

  const DateSelectedState(this.selectedDate);
}

// New states for file upload functionality
class FileUploadInProgress extends PersonalChatState {
  final String clientMessageId;
  final String fileName;
  final double progress;

  const FileUploadInProgress(
      this.clientMessageId, this.fileName, this.progress);
}

class FileUploadComplete extends PersonalChatState {
  final String clientMessageId;
  final String fileName;

  const FileUploadComplete(this.clientMessageId, this.fileName);
}

class FileUploadFailed extends PersonalChatState {
  final String clientMessageId;
  final String fileName;
  final String error;

  const FileUploadFailed(this.clientMessageId, this.fileName, this.error);
}
