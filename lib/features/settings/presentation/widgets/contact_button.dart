import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: context.theme.white100_2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.theme.blue100_1.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: context.theme.blue100_1,
              size: 18,
            ),
            const Gap(8),
            Text(
              label,
              style: AppStyles.semiBold12(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
