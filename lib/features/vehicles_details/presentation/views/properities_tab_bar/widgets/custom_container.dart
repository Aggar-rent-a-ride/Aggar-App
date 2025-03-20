import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.text,
    required this.textColor,
    required this.containerColor,
  });
  final String text;
  final Color textColor;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppLightColors.myBlack25,
              blurRadius: 3,
              offset: const Offset(0, 0),
            )
          ],
          color: containerColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: AppStyles.semiBold16(context).copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
