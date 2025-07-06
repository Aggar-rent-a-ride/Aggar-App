import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationLoadingState extends StatelessWidget {
  const NotificationLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const Gap(16),
          Text(
            'Loading notifications...',
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ],
      ),
    );
  }
}
