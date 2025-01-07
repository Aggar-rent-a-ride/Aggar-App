import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/messages/presentation/widgets/avatar_chat_view.dart';
import 'package:aggar/features/messages/presentation/widgets/name_and_message_chat_view.dart';
import 'package:aggar/features/messages/presentation/widgets/time_and_number_of_msg_chat_view.dart';
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
            overlayColor: WidgetStateProperty.all(AppColors.myBlue10_2),
            backgroundColor: WidgetStateProperty.all(
              Colors.transparent,
            ),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ), // This creates a rectangular shape.
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
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
