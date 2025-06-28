import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final String currency;
  final IconData icon;
  final Color iconColor;

  const BalanceCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.blue10_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.medium20(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
                const Gap(4),
                Text(
                  amount,
                  style: AppStyles.bold36(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
                Text(
                  currency,
                  style: AppStyles.regular16(context).copyWith(
                    color: context.theme.gray100_2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
