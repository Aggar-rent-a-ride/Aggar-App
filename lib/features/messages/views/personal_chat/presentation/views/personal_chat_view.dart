import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/messages/model/dummy.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/app_bar_personal_chat.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_reciver.dart';
import 'package:flutter/material.dart';

import '../widgets/send_messages_with_attach_section.dart';

class PersonalChatView extends StatelessWidget {
  const PersonalChatView({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightColors.myWhite100_1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarPersonalChat(name: name),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: personOne.length,
                    itemBuilder: (context, index) {
                      return ChatBubbleForReciver(
                        message: Message(
                          personOne[index],
                          personTwo[index],
                          "12:00 am",
                        ),
                      );
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
