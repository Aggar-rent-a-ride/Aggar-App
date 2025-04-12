import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomDisplayDiscountColumn extends StatelessWidget {
  const CustomDisplayDiscountColumn(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.hint});
  final String title;
  final String subtitle;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppStyles.medium18(context).copyWith(
            color: AppLightColors.myBlue100_5,
          ),
        ),
        Row(
          children: [
            Text(
              subtitle,
              style: AppStyles.bold28(context).copyWith(
                color: AppLightColors.myBlack50,
              ),
            ),
            const Gap(5),
            Text(
              hint,
              style: AppStyles.bold18(context).copyWith(
                color: AppLightColors.myBlack50,
              ),
            ),
          ],
        )
      ],
    );
  }
}
