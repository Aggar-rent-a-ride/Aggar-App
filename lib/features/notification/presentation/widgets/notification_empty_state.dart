import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: context.theme.blue10_2.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 48,
                color: context.theme.blue100_1,
              ),
            ),
            const Gap(24),
            Text(
              'No notifications yet',
              style: AppStyles.bold18(context).copyWith(
                color: context.theme.black100,
              ),
            ),
            const Gap(8),
            Text(
              'When you receive notifications, they\'ll appear here',
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.black50,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
