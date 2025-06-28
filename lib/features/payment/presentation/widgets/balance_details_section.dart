import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:aggar/features/payment/presentation/widgets/balance_details_list.dart';
import 'package:flutter/material.dart';

class BalanceDetailsSection extends StatelessWidget {
  const BalanceDetailsSection({
    super.key,
    required this.state,
  });
  final PaymentPlatformBalanceSuccess state;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Balance Details",
          style: AppStyles.bold20(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        BalanceDetailsList(
          state: state,
        ),
      ],
    );
  }
}
