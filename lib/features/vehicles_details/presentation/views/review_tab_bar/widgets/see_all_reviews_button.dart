import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SeeAllReviewsButton extends StatelessWidget {
  const SeeAllReviewsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
          ),
          overlayColor: WidgetStatePropertyAll(
            AppColors.myBlue100_8,
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "see all reviews",
              style: AppStyles.medium14(context).copyWith(
                color: AppColors.myBlue100_2,
              ),
            ),
            const Gap(10),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.myBlue100_2,
            ),
          ],
        ),
      ),
    );
  }
}
