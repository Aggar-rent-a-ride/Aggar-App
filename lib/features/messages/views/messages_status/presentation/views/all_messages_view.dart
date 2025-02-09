import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../model/dummy.dart';
import '../../../personal_chat/presentation/views/personal_chat_view.dart';

class AllMessagesView extends StatelessWidget {
  const AllMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      itemCount: names.length,
      itemBuilder: (context, index) => ChatPerson(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalChatView(
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
