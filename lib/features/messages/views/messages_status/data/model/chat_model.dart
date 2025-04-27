import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/last_message_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/user_model.dart';

class ChatModel {
  final List<int> unseenMessageIds;
  final UserModel user;
  final LastMessageModel lastMessage;

  const ChatModel({
    required this.unseenMessageIds,
    required this.user,
    required this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      unseenMessageIds: (json[ApiKey.getMyChatUnSeenMsg] as List<dynamic>)
          .map((id) => id as int)
          .toList(),
      user: UserModel.fromJson(
          json[ApiKey.getMyChatUser] as Map<String, dynamic>),
      lastMessage: LastMessageModel.fromJson(
          json[ApiKey.getMyChatLastMsg] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getMyChatUnSeenMsg: unseenMessageIds,
      ApiKey.getMyChatUser: user.toJson(),
      ApiKey.getMyChatLastMsg: lastMessage.toJson(),
    };
  }
}
