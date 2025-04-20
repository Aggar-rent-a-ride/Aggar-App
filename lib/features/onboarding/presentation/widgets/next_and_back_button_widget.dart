import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class NextandBackButtonWidget extends StatelessWidget {
  const NextandBackButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
  });
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
          foregroundColor: WidgetStatePropertyAll(context.theme.blue100_1),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent)),
      onPressed: onPressed,
      child: Text(
        label,
      ),
    );
  }
}
