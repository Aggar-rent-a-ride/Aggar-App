import 'package:aggar/core/extensions/context_colors_extension.dart';
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
            color: context.theme.black25,
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
            context.theme.white100_2,
          ),
        ),
        onPressed: () {},
        icon: Icon(
          Icons.send,
          color: context.theme.black50,
        ),
      ),
    );
  }
}
