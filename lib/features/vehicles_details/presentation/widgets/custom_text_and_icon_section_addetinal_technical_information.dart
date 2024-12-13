import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTextAndIconSectionAddetinalTechnicalInformation
    extends StatelessWidget {
  const CustomTextAndIconSectionAddetinalTechnicalInformation(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imageIcon});
  final String title;
  final String subtitle;
  final String imageIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage(imageIcon),
          height: 25,
          width: 25,
        ),
        const Gap(2),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.myGray100_2,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.myBlue100_2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
