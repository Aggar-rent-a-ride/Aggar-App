// Contact/Chat list model
class ChatListModel {
  final int userId;
  final String name;
  final String imageUrl;
  String? lastMessage;
  DateTime? lastMessageTime;

  ChatListModel({
    required this.userId,
    required this.name,
    required this.imageUrl,
    this.lastMessage,
    this.lastMessageTime,
  });
}
