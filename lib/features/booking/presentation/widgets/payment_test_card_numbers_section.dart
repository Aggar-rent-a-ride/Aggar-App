import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentTestCardNumbersSection extends StatelessWidget {
  const PaymentTestCardNumbersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.yellow100_1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.theme.yellow100_1.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade700,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Test Card Numbers',
                style: AppStyles.semiBold14(context)
                    .copyWith(color: Colors.amber.shade700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Visa: 4242 4242 4242 4242\nMastercard: 5555 5555 5555 4444\nUse any future date and 123 CVC',
            style: AppStyles.regular13(context).copyWith(
              color: Colors.amber.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
