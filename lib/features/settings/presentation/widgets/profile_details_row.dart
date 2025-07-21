import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileDetailsRow extends StatelessWidget {
  const ProfileDetailsRow({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.color,
  });
  final String label;
  final IconData icon;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 26, color: color ?? context.theme.black50),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.regular12(
                  context,
                ).copyWith(color: context.theme.black50),
              ),
              Text(
                value,
                style: AppStyles.medium14(
                  context,
                ).copyWith(color: context.theme.black100),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
