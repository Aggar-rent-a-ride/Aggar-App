import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_summary_image_with_vehicle_name.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_summary_payment_period.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_summary_total_amount.dart';
import 'package:flutter/material.dart';

class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({
    super.key,
    required this.widget,
  });

  final PaymentScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: AppStyles.semiBold18(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
          PaymentSummaryImageWithVehicleName(widget: widget),
          Divider(
            color: context.theme.black25,
          ),
          PaymentSummaryPaymentPeriod(widget: widget),
          Divider(
            color: context.theme.black25,
          ),
          PaymentSummaryTotalAmount(widget: widget),
        ],
      ),
    );
  }
}
