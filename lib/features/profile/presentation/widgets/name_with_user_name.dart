import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class NameWithUserName extends StatelessWidget {
  const NameWithUserName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Dave C. Brown',
          style: AppStyles.bold24(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        Text(
          '@dave_brown',
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
