import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_card_field.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_secure_info_box.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_test_card_numbers_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentMethodSection extends StatelessWidget {
  final CardEditController cardController;
  final Function(CardFieldInputDetails?) onCardChanged;

  const PaymentMethodSection({
    super.key,
    required this.cardController,
    required this.onCardChanged,
  });

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
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppStyles.semiBold18(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
          PaymentCardField(
            controller: cardController,
            onCardChanged: onCardChanged,
          ),
          const PaymentTestCardNumbersSection(),
          const PaymentSecureInfoBox(),
        ],
      ),
    );
  }
}
