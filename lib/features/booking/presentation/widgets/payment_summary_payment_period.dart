import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_summary_payment_period_list.dart';
import 'package:flutter/material.dart';

class PaymentSummaryPaymentPeriod extends StatelessWidget {
  const PaymentSummaryPaymentPeriod({
    super.key,
    required this.widget,
  });

  final PaymentScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Period",
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        PaymentSummaryPaymentPeriodList(widget: widget)
      ],
    );
  }
}
