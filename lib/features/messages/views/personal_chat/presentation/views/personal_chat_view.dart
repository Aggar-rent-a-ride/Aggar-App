import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/app_bar_personal_chat.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_reciver.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_sender.dart';
import 'package:flutter/material.dart';

import '../widgets/send_messages_with_attach_section.dart';

class PersonalChatView extends StatelessWidget {
  const PersonalChatView({
    super.key,
    required this.messageList,
  });
  final List<MessageModel> messageList;
  @override
  Widget build(BuildContext context) {
    int currentUserId = 20;
    //print(messageList[1].receiverId);
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBarPersonalChat(name: "john doe"),
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
      ),
    );
  }
}
