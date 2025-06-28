import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:aggar/features/payment/presentation/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AccountBalanceSection extends StatelessWidget {
  const AccountBalanceSection({
    super.key,
    required this.state,
  });
  final PaymentPlatformBalanceSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Account Balance",
          style: AppStyles.bold20(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        BalanceCard(
          title: "Total Balance",
          amount: "\$${state.balanceModel.totalBalance}",
          currency: state.balanceModel.currency,
          icon: Iconsax.wallet_3,
          iconColor: context.theme.blue100_1,
        ),
      ],
    );
  }
}
