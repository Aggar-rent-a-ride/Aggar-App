import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomSuffixWidget extends StatelessWidget {
  const CustomSuffixWidget({
    super.key,
    required this.suffixText,
  });

  final String suffixText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: context.theme.gray100_2,
          ),
        ),
      ),
      child: Text(
        suffixText,
        style: AppStyles.medium15(context).copyWith(
          color: context.theme.gray100_2,
        ),
      ),
    );
  }
}
