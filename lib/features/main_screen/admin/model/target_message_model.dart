class TargetMessageModel {
  final String? content;
  final int id;
  final int senderId;
  final int receiverId;
  final String sentAt;
  final bool isSeen;
  TargetMessageModel({
    this.content,
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.isSeen,
  });

  factory TargetMessageModel.fromJson(Map<String, dynamic> json) {
    return TargetMessageModel(
      content: json['content'],
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      sentAt: json['sentAt'],
      isSeen: json['isSeen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (content != null) "content": content,
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'sentAt': sentAt,
      'isSeen': isSeen,
    };
  }
}
