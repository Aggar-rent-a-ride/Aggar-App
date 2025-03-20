import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OwnerNameSection extends StatelessWidget {
  const OwnerNameSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Brian Smith",
            style: AppStyles.bold16(context).copyWith(
              color: AppLightColors.myBlue100_2,
            ),
          ),
          Text(
            "Owner",
            style: AppStyles.semiBold14(context).copyWith(
              color: AppLightColors.myBlack50,
            ),
          )
        ],
      ),
    );
  }
}
