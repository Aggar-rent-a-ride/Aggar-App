import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';

class CustomIndicatorWithText extends StatelessWidget {
  const CustomIndicatorWithText({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.maxValue,
    required this.outterText,
  });
  final double value;
  final String title;
  final String subtitle;
  final double maxValue;
  final String outterText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomIndicator(
          value: value,
          title: title,
          subtitle: subtitle,
          maxValue: maxValue,
        ),
        Text(
          outterText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.myGray100_2,
          ),
        )
      ],
    );
  }
}
