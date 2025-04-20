import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
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
        backgroundColor:
            isActive ? context.theme.blue100_1 : context.theme.white100_1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        label,
        style: AppStyles.medium12(context).copyWith(
          color: isActive ? context.theme.white100_1 : context.theme.black50,
        ),
      ),
    );
  }
}
