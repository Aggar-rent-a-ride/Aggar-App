import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:aggar/features/payment/presentation/widgets/balance_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BalanceDetailsList extends StatelessWidget {
  const BalanceDetailsList({
    super.key,
    required this.state,
  });
  final PaymentPlatformBalanceSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BalanceDetailCard(
          title: "Available Balance",
          subtitle: "Available for use",
          amount: "\$${state.balanceModel.availableBalance}",
          icon: Iconsax.money,
          iconColor: context.theme.green100_1,
        ),
        BalanceDetailCard(
          title: "Pending Balance",
          subtitle: "Processing transactions",
          amount: "\$${state.balanceModel.pendingBalance}",
          icon: Iconsax.clock,
          iconColor: context.theme.yellow100_1,
        ),
        BalanceDetailCard(
          title: "Connect Reserved",
          subtitle: "Reserved for connections",
          amount: "\$${state.balanceModel.connectReserved}",
          icon: Iconsax.lock,
          iconColor: context.theme.red100_1,
        ),
      ],
    );
  }
}
