import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SeeAllReviewsButton extends StatelessWidget {
  const SeeAllReviewsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "see all reviews",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.myBlue100_2,
          ),
        ),
      ),
    );
  }
}
