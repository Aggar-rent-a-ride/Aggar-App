import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_styles.dart';

class ChatBubbleForSender extends StatelessWidget {
  const ChatBubbleForSender({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.2,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: AppLightColors.myBlue100_6,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.message,
                style: AppStyles.medium16(context).copyWith(
                  color: AppLightColors.myWhite100_1,
                ),
              ),
              const Gap(5),
              Text(
                message.time,
                style: AppStyles.medium12(context).copyWith(
                  color: AppLightColors.myWhite100_2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
