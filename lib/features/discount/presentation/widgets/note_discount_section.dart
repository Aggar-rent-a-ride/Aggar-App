import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class NoteDiscountSection extends StatelessWidget {
  const NoteDiscountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Note:",
          style: AppStyles.medium14(context).copyWith(
            color: AppLightColors.myBlack25,
          ),
        ),
        Text(
          overflow: TextOverflow.visible,
          maxLines: 2,
          'Number of days that apply this offer and a percentage must be able to divided by 5',
          style: AppStyles.medium12(context).copyWith(
            color: AppLightColors.myBlack25,
          ),
        ),
      ],
    );
  }
}
