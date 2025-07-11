import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.white100_1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.theme.blue100_1.withOpacity(0.1),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.theme.blue100_1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: context.theme.blue100_1,
                size: 24,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.semiBold16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: AppStyles.regular12(context).copyWith(
                      color: context.theme.black100.withOpacity(0.7),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    value,
                    style: AppStyles.semiBold14(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.theme.blue100_1,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
