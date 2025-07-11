import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.grey100_1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: context.theme.black50,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.regular12(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.semiBold16(context).copyWith(
                    color: valueColor ?? context.theme.black100,
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
