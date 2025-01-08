import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/messages/presentation/views/personal_chat/presentation/widgets/app_bar_person_message.dart';
import 'package:aggar/features/messages/presentation/views/personal_chat/presentation/widgets/send_messages_with_attach_section.dart';
import 'package:flutter/material.dart';

class PersonMessagesView extends StatelessWidget {
  const PersonMessagesView({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.13,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.myBlue100_1,
              boxShadow: [
                BoxShadow(
                  color: AppColors.myBlack10,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppBarPersonMessage(name: name),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SendMessagesWithAttachSection(),
    );
  }
}
