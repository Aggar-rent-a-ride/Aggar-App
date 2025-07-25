import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;
  final Color? iconColor;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.medium14(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        const Gap(8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.theme.black25,
            ),
            borderRadius: BorderRadius.circular(8),
            color: context.theme.white100_1,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: AppStyles.regular14(context).copyWith(
                      color: value == placeholder
                          ? context.theme.black50
                          : context.theme.black100,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: iconColor ?? context.theme.black50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
