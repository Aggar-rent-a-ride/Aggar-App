import 'package:aggar/core/extensions/context_colors_extension.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppStyles.semiBold15(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Row(
          children: [
            Text(
              subtitle,
              style: AppStyles.bold28(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            const Gap(5),
            Text(
              hint,
              style: AppStyles.bold18(context).copyWith(
                color: context.theme.black50,
              ),
            ),
          ],
        )
      ],
    );
  }
}
