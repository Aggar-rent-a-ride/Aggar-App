import 'package:aggar/core/widgets/filter_apply_button.dart';
import 'package:aggar/core/widgets/filter_clear_button.dart';
import 'package:flutter/material.dart';

class FilterApplyWithClearButtons extends StatelessWidget {
  const FilterApplyWithClearButtons({
    super.key,
    this.onPressedApply,
    this.onPressedClear,
  });
  final void Function()? onPressedApply;
  final void Function()? onPressedClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterClearButton(
          clearFunction: onPressedClear,
        ),
        FilterApplyButton(
          onPressed: onPressedApply,
        ),
      ],
    );
  }
}
