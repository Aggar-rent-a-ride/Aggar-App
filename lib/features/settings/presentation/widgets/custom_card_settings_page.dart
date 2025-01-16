import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCardSettingsPage extends StatelessWidget {
  const CustomCardSettingsPage({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
    this.onPressed,
  });
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(AppColors.myBlue10_2),
        backgroundColor: WidgetStateProperty.all(backgroundColor),

        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(
              color: borderColor,
            ),
          ),
        ), // This creates a rectangular shape.
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: child,
      ),
    );
  }
}
