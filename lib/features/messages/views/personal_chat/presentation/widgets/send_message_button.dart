import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RealTimeChatCubit>();
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: cubit.messageController,
      builder: (context, value, child) {
        final bool hasText = value.text.trim().isNotEmpty;
        return Container(
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
          child: IconButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.all(14),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              backgroundColor: WidgetStateProperty.all(
                hasText ? context.theme.blue100_1 : context.theme.white100_2,
              ),
            ),
            onPressed: hasText ? () => _sendMessage(context) : null,
            icon: Icon(
              Icons.send,
              color: hasText ? context.theme.white100_2 : context.theme.black50,
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendMessage(BuildContext context) async {
    final cubit = context.read<RealTimeChatCubit>();
    try {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            "Error",
            "Authentication error. Please login again.",
            SnackBarType.error,
          ),
        );
        return;
      }
      await cubit.sendMessage(accessToken);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Error",
          "Failed to send message: ${e.toString()}",
          SnackBarType.error,
        ),
      );
    }
  }
}
