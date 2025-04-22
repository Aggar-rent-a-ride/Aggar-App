import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardType extends StatelessWidget {
  const CardType({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData? icon;
  final String? title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isSelected ? context.theme.blue100_2 : context.theme.black25,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? context.theme.blue100_2.withOpacity(0.15)
              : context.theme.white100_1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.person,
              size: 50,
              color:
                  isSelected ? context.theme.blue100_2 : context.theme.black25,
            ),
            const Gap(6),
            Text(
              title ?? 'User',
              style: AppStyles.regular20(context).copyWith(
                color: isSelected
                    ? context.theme.blue100_2
                    : context.theme.black25,
              ),
            ),
            Text(
              subtitle ?? 'Can use cars & buy for them',
              style: AppStyles.regular12(context).copyWith(
                color: isSelected
                    ? context.theme.blue100_2
                    : context.theme.black25,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
