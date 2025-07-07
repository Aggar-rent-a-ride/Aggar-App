import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: context.theme.black50,
          ),
          const SizedBox(height: 16),
          Text(
            'No booking history found',
            style: AppStyles.bold18(context).copyWith(
              color: context.theme.black50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking history will appear here',
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ],
      ),
    );
  }
}
