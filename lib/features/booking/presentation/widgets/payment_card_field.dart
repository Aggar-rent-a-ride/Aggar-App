import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentCardField extends StatelessWidget {
  final CardEditController controller;
  final Function(CardFieldInputDetails?) onCardChanged;

  const PaymentCardField({
    super.key,
    required this.controller,
    required this.onCardChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.black25),
      ),
      child: CardField(
        controller: controller,
        onCardChanged: onCardChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Card number',
          hintStyle: AppStyles.medium16(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        enablePostalCode: false,
        autofocus: false,
        style: AppStyles.semiBold16(context).copyWith(
          color: context.theme.black100, // Changed from blue100_1 to black100
        ),
      ),
    );
  }
}
