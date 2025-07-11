import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final VoidCallback onDone;

  const PaymentSuccessDialog({
    super.key,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.theme.white100_1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.green.shade600,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Payment Successful!',
            style: AppStyles.bold20(context).copyWith(
              color: context.theme.black100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking has been confirmed. You will receive a confirmation email shortly.',
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.black50,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.blue100_1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Done',
                style: AppStyles.semiBold18(context).copyWith(
                  color: context.theme.white100_1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
