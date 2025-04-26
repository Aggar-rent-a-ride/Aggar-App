import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/message_text_field_with_attachment_button.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/send_message_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TypeMessageTextFieldWithSendButton extends StatelessWidget {
  const TypeMessageTextFieldWithSendButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          MessageTextFieldWithAttachmentButton(),
          Gap(10),
          SendMessageButton(),
        ],
      ),
    );
  }
}
