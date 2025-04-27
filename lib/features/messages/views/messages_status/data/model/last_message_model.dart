import 'package:aggar/core/api/end_points.dart';

class LastMessageModel {
  final int id;
  final String sentAt;
  final bool isSeen;
  final String? content;
  final String? filePath;

  LastMessageModel({
    required this.id,
    required this.sentAt,
    required this.isSeen,
    this.content,
    this.filePath,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json[ApiKey.getMyChatLastMsgId],
      sentAt: json[ApiKey.getMyChatLastMsgSentAt],
      isSeen: json[ApiKey.getMtChatLastMsgSeen],
      content: json[ApiKey.getMyChatLastMsgContent],
      filePath: json[ApiKey.getMyChatLastMsgFilePath],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getMyChatLastMsgId: id,
      ApiKey.getMyChatLastMsgSentAt: sentAt,
      ApiKey.getMyChatUnSeenMsg: isSeen,
      if (content != null) ApiKey.getMyChatLastMsgContent: content,
      if (filePath != null) ApiKey.getMyChatLastMsgFilePath: filePath,
    };
  }
}
