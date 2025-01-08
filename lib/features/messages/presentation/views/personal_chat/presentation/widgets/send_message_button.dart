import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(14),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          AppColors.myGray100_5,
        ),
      ),
      onPressed: () {},
      icon: const Icon(Icons.send),
    );
  }
}
