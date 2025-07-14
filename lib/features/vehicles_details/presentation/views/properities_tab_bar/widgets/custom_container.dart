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
          border: Border.all(
            color: containerColor.withOpacity(0.15),
            width: 1,
          ),
          color: containerColor.withOpacity(0.1),
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
