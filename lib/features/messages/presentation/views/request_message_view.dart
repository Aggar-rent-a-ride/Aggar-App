import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/messages/presentation/views/chat_view.dart';
import 'package:aggar/features/messages/presentation/widgets/chat_person.dart';
import 'package:flutter/material.dart';

class RequestMessageView extends StatelessWidget {
  const RequestMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, right: 0, left: 0, bottom: 0),
      itemCount: names.length,
      itemBuilder: (context, index) => ChatPerson(
        onTap: () {},
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
