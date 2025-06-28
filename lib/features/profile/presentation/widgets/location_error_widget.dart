import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LocationErrorWidget extends StatelessWidget {
  const LocationErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 64,
            color: context.theme.black50,
          ),
          const Gap(16),
          Text(
            'Unable to load location',
            style: AppStyles.semiBold18(context).copyWith(
              color: context.theme.black100,
            ),
          ),
          const Gap(8),
          Text(
            'Please check your connection and try again',
            style: AppStyles.regular14(context).copyWith(
              color: context.theme.black50,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
        ],
      ),
    );
  }
}
