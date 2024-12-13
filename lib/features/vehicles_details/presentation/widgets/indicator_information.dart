import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class IndicatorInformation extends StatelessWidget {
  const IndicatorInformation({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 21,
            color: AppColors.myBlue100_2,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.myGray100_2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
