import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class BackOutLineButton extends StatelessWidget {
  const BackOutLineButton({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: context.theme.blue100_1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Back",
          style: TextStyle(
            color: context.theme.blue100_1,
          ),
        ),
      ),
    );
  }
}
