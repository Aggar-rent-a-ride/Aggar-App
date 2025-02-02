import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.myBlack25,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: IconButton(
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
        icon: Icon(
          Icons.send,
          color: AppColors.myBlack50,
        ),
      ),
    );
  }
}
