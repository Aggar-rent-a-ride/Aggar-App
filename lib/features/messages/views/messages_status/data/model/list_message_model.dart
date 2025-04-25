import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';

class ListMessageModel {
  final List<MessageModel> data;

  ListMessageModel({
    required this.data,
  });

  factory ListMessageModel.fromJson(Map<String, dynamic> json) {
    return ListMessageModel(
      data: List<MessageModel>.from(
        (json['data'] as List).map(
          (message) => MessageModel.fromJson(message),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((message) => message.toJson()).toList(),
    };
  }
}
