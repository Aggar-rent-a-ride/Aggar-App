import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentDetailsBalanceOverviewCard extends StatelessWidget {
  const PaymentDetailsBalanceOverviewCard({
    super.key,
    required this.currentAmount,
    required this.upcomingAmount,
    required this.totalBalance,
  });
  final double currentAmount;
  final double upcomingAmount;
  final double totalBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.blue100_1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.theme.blue100_1.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Balance",
            style: AppStyles.medium16(context).copyWith(
              color: context.theme.blue100_1.withOpacity(0.8),
            ),
          ),
          const Gap(8),
          Text(
            "\$$totalBalance",
            style: AppStyles.bold28(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Amount",
                    style: AppStyles.medium12(context).copyWith(
                      color: context.theme.blue100_1.withOpacity(0.7),
                    ),
                  ),
                  const Gap(5),
                  Text(
                    "\$$currentAmount",
                    style: AppStyles.bold16(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Upcoming Amount",
                    style: AppStyles.medium12(context).copyWith(
                      color: context.theme.blue100_1.withOpacity(0.7),
                    ),
                  ),
                  const Gap(5),
                  Text(
                    "\$$upcomingAmount",
                    style: AppStyles.bold16(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
