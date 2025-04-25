class MessageModel {
  final String clientMessageId;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime timestamp;
  final bool isMe;

  MessageModel({
    required this.clientMessageId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });
}

