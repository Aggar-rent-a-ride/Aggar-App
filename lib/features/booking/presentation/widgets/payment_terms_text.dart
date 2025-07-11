import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentTermsText extends StatelessWidget {
  const PaymentTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'By completing this payment, you agree to our Terms of Service and Privacy Policy.',
      style: AppStyles.medium14(context).copyWith(
        color: context.theme.black50,
      ),
      textAlign: TextAlign.center,
    );
  }
}
