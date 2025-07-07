// lib/features/discount/presentation/widgets/custom_elevation_button.dart
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';

class CustomElevationButton extends StatelessWidget {
  const CustomElevationButton({
    super.key,
    this.paddingHorizental,
    this.paddingVertical,
    required this.title,
    this.isSelected = false,
    required this.onPressed,
  });

  final double? paddingHorizental;
  final double? paddingVertical;
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: context.theme.blue100_2,
              width: 1,
            ),
          ),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: paddingHorizental ?? 0,
            vertical: paddingVertical ?? 0,
          ),
        ),
        overlayColor: WidgetStatePropertyAll(
          context.theme.white100_2,
        ),
        backgroundColor: WidgetStatePropertyAll(
          isSelected ? context.theme.white100_1 : context.theme.blue100_1,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: AppStyles.semiBold16(context).copyWith(
          color:
              isSelected ? context.theme.blue100_1 : context.theme.white100_1,
        ),
      ),
    );
  }
}
