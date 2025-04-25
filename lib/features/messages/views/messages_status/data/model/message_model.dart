import 'package:aggar/core/api/end_points.dart';

class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String sentAt;
  final bool isSeen;
  final String? content;
  final String? filePath;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.isSeen,
    this.content,
    this.filePath,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json[ApiKey.msgId],
      senderId: json[ApiKey.msgSenderId],
      receiverId: json[ApiKey.msgReceiverId],
      sentAt: json[ApiKey.msgDate],
      isSeen: json[ApiKey.msgStatus],
      content: json[ApiKey.msgContent],
      filePath: json[ApiKey.msgFilePath],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.msgId: id,
      ApiKey.msgSenderId: senderId,
      ApiKey.msgReceiverId: receiverId,
      ApiKey.msgDate: sentAt,
      ApiKey.msgStatus: isSeen,
      if (content != null) ApiKey.msgContent: content,
      if (filePath != null) ApiKey.msgFilePath: filePath,
    };
  }
}
