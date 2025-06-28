import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LocationLoadingWidget extends StatelessWidget {
  const LocationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.theme.blue100_1,
          ),
          const Gap(16),
          Text(
            'Loading location...',
            style: AppStyles.medium16(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ],
      ),
    );
  }
}
