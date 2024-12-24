import 'package:aggar/features/chat/presentation/widgets/avatar_chat_view.dart';
import 'package:aggar/features/chat/presentation/widgets/name_and_message_chat_view.dart';
import 'package:aggar/features/chat/presentation/widgets/time_and_number_of_msg_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatPerson extends StatelessWidget {
  const ChatPerson(
      {super.key,
      required this.name,
      required this.msg,
      required this.time,
      required this.numberMsg,
      required this.image});
  final String name;
  final String msg;
  final String time;
  final int numberMsg;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
