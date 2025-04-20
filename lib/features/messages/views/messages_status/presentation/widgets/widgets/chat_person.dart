import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/name_and_message_chat_view.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/time_and_number_of_msg_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatPerson extends StatelessWidget {
  const ChatPerson(
      {super.key,
      required this.name,
      required this.msg,
      required this.time,
      required this.numberMsg,
      required this.image,
      this.onTap});
  final String name;
  final String msg;
  final String time;
  final int numberMsg;
  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(context.theme.blue10_2),
            backgroundColor: WidgetStateProperty.all(
              Colors.transparent,
            ),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 25,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  AvatarChatView(
                    image: image,
                  ),
                  const Gap(10),
                  NameAndMessageChatView(
                    name: name,
                    msg: msg,
                  ),
                  TimeAndNumberOfMsgChatView(
                    time: time,
                    numberMsg: numberMsg,
                  )
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Divider(),
        ),
      ],
    );
  }
}
