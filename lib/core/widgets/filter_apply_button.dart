import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart' show AppStyles;
import 'package:flutter/material.dart';

class FilterApplyButton extends StatelessWidget {
  const FilterApplyButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.blue100_6,
        foregroundColor: context.theme.white100_1,
      ),
      child: Text(
        "Apply",
        style: AppStyles.semiBold16(context).copyWith(
          color: context.theme.white100_1,
        ),
      ),
    );
  }
}
