import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;
  final String label;

  const CustomElevatedButton({
    super.key,
    required this.isActive,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppLightColors.myBlue100_1 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
