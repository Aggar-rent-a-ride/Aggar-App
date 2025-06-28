import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class PaymentErrorScreen extends StatelessWidget {
  const PaymentErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(20),
          Icon(
            Iconsax.warning_2,
            color: context.theme.red100_1,
            size: 48,
          ),
          const Gap(12),
          Text(
            "Failed to load balance",
            style: AppStyles.medium18(context).copyWith(
              color: context.theme.gray100_2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
