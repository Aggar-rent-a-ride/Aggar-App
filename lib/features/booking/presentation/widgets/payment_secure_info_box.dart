import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentSecureInfoBox extends StatelessWidget {
  const PaymentSecureInfoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.security,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your payment information is secure and encrypted.',
              style: AppStyles.medium14(context).copyWith(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
