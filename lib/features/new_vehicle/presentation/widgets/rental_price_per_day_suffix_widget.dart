import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class RentalPricePerDaySuffixWidget extends StatelessWidget {
  const RentalPricePerDaySuffixWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: AppColors.myBlack50,
          ),
        ),
      ),
      child: Text(
        r"$$",
        style: AppStyles.medium15(context).copyWith(
          color: AppColors.myBlack50,
        ),
      ),
    );
  }
}
