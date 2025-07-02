import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NoDiscountYetSection extends StatelessWidget {
  const NoDiscountYetSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.theme.grey100_1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.theme.grey100_1.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_offer_outlined,
            color: context.theme.black50,
            size: 48,
          ),
          const Gap(12),
          Text(
            'No discounts yet',
            style: AppStyles.bold16(context).copyWith(
              color: context.theme.black50,
            ),
          ),
          const Gap(4),
          Text(
            'Add your first discount to attract more customers',
            style: AppStyles.medium12(context).copyWith(
              color: context.theme.black50,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
