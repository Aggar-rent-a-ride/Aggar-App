class RealTimeChatState {
  const RealTimeChatState();
}

class RealTimeChatInitial extends RealTimeChatState {
  const RealTimeChatInitial();
}

class RealTimeChatLoading extends RealTimeChatState {
  const RealTimeChatLoading();
}

class RealTimeChatFailure extends RealTimeChatState {
  final String message;
  const RealTimeChatFailure(this.message);
}

class SenderIdInitialized extends RealTimeChatState {
  final int senderId;
  const SenderIdInitialized(this.senderId);
}

class MessageSentSuccessfully extends RealTimeChatState {
  final String messageId;
  const MessageSentSuccessfully(this.messageId);
}

class MessageAddedState extends RealTimeChatState {
  final dynamic message;
  const MessageAddedState(this.message);
}

class MessageUpdatedState extends RealTimeChatState {
  final dynamic message;
  const MessageUpdatedState(this.message);
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
  final String errorMessage;
  const FileUploadFailed(
      this.clientMessageId, this.fileName, this.errorMessage);
}

class SearchResultsState extends RealTimeChatState {
  final String searchQuery;
  final String? highlightedMessageId;
  final bool isDateSearch;

  const SearchResultsState({
    required this.searchQuery,
    this.highlightedMessageId,
    this.isDateSearch = false,
  });
}

class ConnectionStatusChanged extends RealTimeChatState {
  final bool isConnected;
  const ConnectionStatusChanged(this.isConnected);
}
