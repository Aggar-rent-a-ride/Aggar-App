import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class BalanceDetailCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color iconColor;

  const BalanceDetailCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<BalanceDetailCard> createState() => _BalanceDetailCardState();
}

class _BalanceDetailCardState extends State<BalanceDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: widget.iconColor.withOpacity(0.1),
            child: Icon(widget.icon, color: widget.iconColor, size: 24),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: AppStyles.regular14(context).copyWith(
                    color: context.theme.gray100_2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.amount,
            style: AppStyles.bold18(context).copyWith(
              color: context.theme.black100,
            ),
          ),
        ],
      ),
    );
  }
}
