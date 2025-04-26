import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_reciver.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_sender.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/send_messages_with_attach_section.dart';
import 'package:flutter/material.dart';

class PersonalChatBody extends StatelessWidget {
  const PersonalChatBody({
    super.key,
    required this.messageList,
    required this.currentUserId,
  });

  final List<MessageModel> messageList;
  final int currentUserId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    MessageModel message = messageList[index];
                    if (message.senderId == currentUserId) {
                      return ChatBubbleForSender(
                        isfile: message.filePath != null,
                        message: Message(
                          message.content == null
                              ? message.filePath!
                              : message.content!,
                          message.id.toString(),
                          message.sentAt,
                        ),
                      );
                    } else {
                      return ChatBubbleForReciver(
                        isfile: message.filePath != null,
                        message: Message(
                          message.content == null
                              ? message.filePath!
                              : message.content!,
                          message.id.toString(),
                          message.sentAt,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SendMessagesWithAttachSection(),
            ],
          ),
        )
      ],
    );
  }
}
