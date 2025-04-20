import 'package:aggar/core/extensions/context_colors_extension.dart';

import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class MessageTextFieldWithAttachmentButton extends StatelessWidget {
  const MessageTextFieldWithAttachmentButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: context.theme.black25,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
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
                angle: 45 * (3.1415927 / 180), // Convert 45 degrees to radians
                child: IconButton(
                  onPressed: () {},
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
}
