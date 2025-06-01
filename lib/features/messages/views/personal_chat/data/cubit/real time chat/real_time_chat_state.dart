import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart'
    show MessageModel;

abstract class RealTimeChatState {
  const RealTimeChatState();
}

class RealTimeChatInitial extends RealTimeChatState {
  const RealTimeChatInitial();
}

class RealTimeChatLoading extends RealTimeChatState {
  const RealTimeChatLoading();
}

class MessagesLoading extends RealTimeChatState {
  const MessagesLoading();
}

class MessagesLoaded extends RealTimeChatState {
  const MessagesLoaded();
}

class RealTimeChatFailure extends RealTimeChatState {
  final String error;

  const RealTimeChatFailure(this.error);
}

class MessageAddedState extends RealTimeChatState {
  final MessageModel message;

  const MessageAddedState(this.message);
}

class MessageUpdatedState extends RealTimeChatState {
  final MessageModel message;

  const MessageUpdatedState(this.message);
}

class MessageSentSuccessfully extends RealTimeChatState {
  final String clientMessageId;

  const MessageSentSuccessfully(this.clientMessageId);
}

class FileUploadInProgress extends RealTimeChatState {
  final String clientMessageId;
  final String fileName;
  final double progress;

  const FileUploadInProgress(
      this.clientMessageId, this.fileName, this.progress);
}

class FileUploadComplete extends RealTimeChatState {
  final String clientMessageId;
  final String fileName;

  const FileUploadComplete(this.clientMessageId, this.fileName);
}

class FileUploadFailed extends RealTimeChatState {
  final String clientMessageId;
  final String fileName;
  final String error;

  const FileUploadFailed(this.clientMessageId, this.fileName, this.error);
}

class ConnectionStatusChanged extends RealTimeChatState {
  final bool isConnected;

  const ConnectionStatusChanged(this.isConnected);
}

class SenderIdInitialized extends RealTimeChatState {
  final int senderId;

  const SenderIdInitialized(this.senderId);
}
