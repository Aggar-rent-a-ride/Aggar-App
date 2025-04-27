import 'package:aggar/features/messages/views/messages_status/data/model/chat_model.dart';

class ListChatModel {
  final List<ChatModel> data;

  const ListChatModel({
    required this.data,
  });

  factory ListChatModel.fromJson(Map<String, dynamic> json) {
    return ListChatModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => ChatModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((chat) => chat.toJson()).toList(),
    };
  }
}
