import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NoReviewUser extends StatelessWidget {
  const NoReviewUser({
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.theme.blue100_2.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.rate_review_outlined,
                size: 40,
                color: context.theme.blue100_2,
              ),
            ),
            const Gap(25),
            Text(
              'No reviews available',
              style: AppStyles.bold18(context).copyWith(
                color: context.theme.black50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
