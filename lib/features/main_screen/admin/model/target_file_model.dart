class TargetFileModel {
  final String? filePath;
  final int id;
  final int senderId;
  final int receiverId;
  final String sentAt;
  final bool isSeen;

  TargetFileModel({
    this.filePath,
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.isSeen,
  });

  factory TargetFileModel.fromJson(Map<String, dynamic> json) {
    return TargetFileModel(
      filePath: json["filePath"],
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      sentAt: json['sentAt'],
      isSeen: json['isSeen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (filePath != null) "filePath": filePath,
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'sentAt': sentAt,
      'isSeen': isSeen,
    };
  }
}
