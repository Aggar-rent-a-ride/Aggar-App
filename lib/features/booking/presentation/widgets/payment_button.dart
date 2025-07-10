import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  final bool isProcessing;
  final bool isEnabled;
  final double amount;
  final VoidCallback onPressed;

  const PaymentButton({
    super.key,
    required this.isProcessing,
    required this.isEnabled,
    required this.amount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: isProcessing || !isEnabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.blue100_1,
          disabledBackgroundColor: context.theme.black50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Pay \$${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
