class ChatMessage {
  final int id;
  final String clientMessageId;
  final int senderId;
  final int receiverId;
  final DateTime sentAt;
  final bool seen;
  final String? content;
  final String? filePath;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.clientMessageId,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.seen,
    this.content,
    this.filePath,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {required int currentUserId}) {
    return ChatMessage(
      id: json['Id'] ?? 0,
      clientMessageId: json['ClientMessageId'] ?? '',
      senderId: json['SenderId'] ?? 0,
      receiverId: json['ReceiverId'] ?? 0,
      sentAt: json['SentAt'] != null
          ? DateTime.parse(json['SentAt'])
          : DateTime.now(),
      seen: json['Seen'] ?? false,
      content: json['Content'],
      filePath: json['FilePath'],
      isMe: json['SenderId'] == currentUserId,
    );
  }
}

class UploadInitiationResponse {
  final String filePath;
  final String clientMessageId;

  UploadInitiationResponse({
    required this.filePath,
    required this.clientMessageId,
  });

  factory UploadInitiationResponse.fromJson(Map<String, dynamic> json) {
    return UploadInitiationResponse(
      filePath: json['FilePath'] ?? '',
      clientMessageId: json['ClientMessageId'] ?? '',
    );
  }
}

class UploadProgress {
  final String clientMessageId;
  final int bytesUploaded;
  final double progressPercentage;

  UploadProgress({
    required this.clientMessageId,
    required this.bytesUploaded,
    required this.progressPercentage,
  });

  factory UploadProgress.fromJson(Map<String, dynamic> json,
      {int totalBytes = 1}) {
    final bytesUploaded = json['Progress'] ?? 0;
    return UploadProgress(
      clientMessageId: json['ClientMessageId'] ?? '',
      bytesUploaded: bytesUploaded,
      progressPercentage:
          totalBytes > 0 ? (bytesUploaded / totalBytes) * 100 : 0,
    );
  }
}

class UserConnectionStatus {
  final int userId;
  final bool isConnected;

  UserConnectionStatus({
    required this.userId,
    required this.isConnected,
  });
}
