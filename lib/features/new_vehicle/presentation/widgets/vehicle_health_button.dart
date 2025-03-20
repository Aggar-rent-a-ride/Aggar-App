import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class VehicleHealthButton extends StatelessWidget {
  const VehicleHealthButton({
    super.key,
    required this.text,
    this.isSelected = false,
    required this.onPressed,
  });

  final String text;
  final bool isSelected;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: AppLightColors.myBlack25,
            blurRadius: 4,
          )
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected
                    ? AppLightColors.myBlue100_1
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          ),
          overlayColor: WidgetStatePropertyAll(
            AppLightColors.myWhite50_1,
          ),
          backgroundColor: WidgetStatePropertyAll(
            isSelected
                ? AppLightColors.myWhite100_1
                : AppLightColors.myBlue100_2,
          ),
        ),
        onPressed: () => onPressed(text),
        child: Text(
          text,
          style: AppStyles.semiBold16(context).copyWith(
            color: isSelected
                ? AppLightColors.myBlue100_1
                : AppLightColors.myWhite100_1,
          ),
        ),
      ),
    );
  }
}
