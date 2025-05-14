import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageTextFieldWithAttachmentButton extends StatelessWidget {
  const MessageTextFieldWithAttachmentButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RealTimeChatCubit>();
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
          controller: cubit.messageController,
          cursorColor: context.theme.blue100_2,
          cursorOpacityAnimates: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: context.theme.white100_2,
            hintText: 'Message',
            hintStyle: AppStyles.medium18(context).copyWith(
              color: context.theme.black50,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Transform.rotate(
                angle: 45 * (3.1415927 / 180),
                child: IconButton(
                  onPressed: () {
                    _pickAndSendFile(context);
                  },
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: context.theme.black50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndSendFile(BuildContext context) async {
    final cubit = context.read<RealTimeChatCubit>();
    try {
      await cubit.pickAndSendFile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
