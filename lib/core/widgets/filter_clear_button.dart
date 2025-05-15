import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart' show AppStyles;
import 'package:flutter/material.dart';

class FilterClearButton extends StatelessWidget {
  const FilterClearButton({
    super.key,
    this.clearFunction,
  });

  final void Function()? clearFunction;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: clearFunction,
      child: Text(
        "Clear",
        style: AppStyles.medium16(context).copyWith(
          color: context.theme.blue100_8,
        ),
      ),
    );
  }
}
