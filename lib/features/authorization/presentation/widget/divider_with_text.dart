import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: context.theme.black50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "or continue with",
            style: AppStyles.medium18(context).copyWith(
              color: context.theme.black25,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: context.theme.black25,
          ),
        ),
      ],
    );
  }
}
