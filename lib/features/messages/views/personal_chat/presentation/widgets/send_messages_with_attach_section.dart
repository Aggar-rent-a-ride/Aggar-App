import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/type_message_text_field_with_send_button.dart';
import 'package:flutter/material.dart';

class SendMessagesWithAttachSection extends StatelessWidget {
  const SendMessagesWithAttachSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.09,
      width: double.infinity,
      color: context.theme.white100_1,
      child: const TypeMessageTextFieldWithSendButton(),
    );
  }
}
