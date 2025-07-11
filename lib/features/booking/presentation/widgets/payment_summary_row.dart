import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentSummaryRow extends StatelessWidget {
  const PaymentSummaryRow({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.regular14(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        Text(
          value,
          style: AppStyles.medium15(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
      ],
    );
  }
}
