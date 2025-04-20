import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextAndIconSection extends StatelessWidget {
  const TextAndIconSection(
      {super.key, required this.title, required this.imageIcon, this.width});
  final String title;
  final String imageIcon;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(imageIcon),
          height: 16,
          width: 16,
        ),
        Gap(width ?? 0),
        Text(
          title,
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
      ],
    );
  }
}
