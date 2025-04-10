// lib/features/discount/presentation/widgets/custom_elevation_button.dart
import 'package:aggar/core/themes/app_light_colors.dart';
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
              color: AppLightColors.myBlue100_2,
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
          AppLightColors.myWhite50_1,
        ),
        backgroundColor: WidgetStatePropertyAll(
          isSelected ? AppLightColors.myBlue100_2 : AppLightColors.myWhite100_1,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: AppStyles.semiBold16(context).copyWith(
          color: isSelected
              ? AppLightColors.myWhite100_1
              : AppLightColors.myBlue100_2,
        ),
      ),
    );
  }
}
