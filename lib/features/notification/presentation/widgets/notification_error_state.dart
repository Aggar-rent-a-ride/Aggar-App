import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationErrorState extends StatelessWidget {
  final String message;

  const NotificationErrorState({
    super.key,
    required this.message,
  });

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
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
            ),
            const Gap(24),
            Text(
              'Something went wrong',
              style: AppStyles.bold18(context).copyWith(
                color: context.theme.black100,
              ),
            ),
            const Gap(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            const Gap(24),
            ElevatedButton.icon(
              onPressed: () => context.read<NotificationCubit>().initialize(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.blue100_1,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
