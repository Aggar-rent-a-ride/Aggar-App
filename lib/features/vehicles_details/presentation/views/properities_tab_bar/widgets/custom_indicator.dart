import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/custom_circular_percent_indecitor.dart';
import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.maxValue,
  });
  final double value;
  final String title;
  final String subtitle;
  final double maxValue;
  @override
  Widget build(BuildContext context) {
    double percentage = (value / maxValue).clamp(0.0, 1.0);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: AppColors.myWhite100_3,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: AppColors.myBlack25,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: CustomCircularPercentIndecitor(
          percentage: percentage, title: title, subtitle: subtitle),
    );
  }
}
