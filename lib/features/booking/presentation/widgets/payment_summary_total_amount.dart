import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:flutter/material.dart';

class PaymentSummaryTotalAmount extends StatelessWidget {
  const PaymentSummaryTotalAmount({
    super.key,
    required this.widget,
  });

  final PaymentScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Amount',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        Text(
          '\$${widget.amount.toStringAsFixed(2)}',
          style: AppStyles.semiBold20(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
      ],
    );
  }
}
