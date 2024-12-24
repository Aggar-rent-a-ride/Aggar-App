import 'package:aggar/features/chat/presentation/widgets/chat_person.dart';
import '../../../../core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => const ChatPerson(
          name: "Brian Smith",
          msg:
              "Hello! Excited to connect with everyone!Hello! Excited to connect with everyone!",
          time: "12:00 am",
          numberMsg: 8,
          image: AppAssets.assetsImagesAvatar,
        ),
      ),
    );
  }
}
