import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MessageTextFieldWithAttachmentButton extends StatelessWidget {
  const MessageTextFieldWithAttachmentButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.myGray100_5,
          hintText: 'Message',
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.rotate(
              angle: 45 * (3.1415927 / 180), // Convert 45 degrees to radians
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.attach_file_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
