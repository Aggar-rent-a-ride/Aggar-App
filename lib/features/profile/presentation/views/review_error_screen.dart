import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviewErrorScreen extends StatelessWidget {
  const ReviewErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: context.theme.gray100_2,
            ),
            const Gap(16),
            Text(
              "Something went wrong",
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.gray100_2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
