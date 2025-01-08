import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/messages/presentation/views/personal_chat/presentation/views/person_messages_view.dart';
import 'package:aggar/features/messages/presentation/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:flutter/material.dart';

import '../../../../../model/dummy.dart';

class RequestMessageView extends StatelessWidget {
  const RequestMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, right: 0, left: 0, bottom: 0),
      itemCount: names.length,
      itemBuilder: (context, index) => ChatPerson(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonMessagesView(
                name: names[index],
              ),
            ),
          );
        },
        name: names[index],
        msg:
            "Hello! Excited to connect everyone!Hello! Excited to connect with everyone!",
        time: "12:00 am",
        numberMsg: 8,
        image: AppAssets.assetsImagesAvatar,
      ),
    );
  }
}
