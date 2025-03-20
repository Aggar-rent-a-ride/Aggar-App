import 'package:aggar/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCardSettingsPage extends StatelessWidget {
  const CustomCardSettingsPage({
    super.key,
    required this.backgroundColor,
    this.borderColor,
    required this.child,
    this.onPressed,
    required this.padingVeritical,
    required this.padingHorizental,
  });
  final Color backgroundColor;
  final Color? borderColor;
  final Widget child;
  final double padingVeritical;
  final double padingHorizental;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(AppLightColors.myBlue10_2),
        backgroundColor: WidgetStateProperty.all(backgroundColor),

        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
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
        padding: EdgeInsets.symmetric(
          vertical: padingVeritical,
          horizontal: padingHorizental,
        ),
        child: child,
      ),
    );
  }
}
