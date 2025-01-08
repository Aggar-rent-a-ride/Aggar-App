import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/messages/presentation/views/personal_chat/presentation/widgets/type_message_text_field_with_send_button.dart';
import 'package:flutter/material.dart';

class SendMessagesWithAttachSection extends StatelessWidget {
  const SendMessagesWithAttachSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.11,
      width: double.infinity,
      color: AppColors.myWhite100_1,
      child: const TypeMessageTextFieldWithSendButton(),
    );
  }
}
