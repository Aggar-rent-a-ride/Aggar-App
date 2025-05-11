import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class NearestFilterChip extends StatefulWidget {
  const NearestFilterChip({
    super.key,
  });

  @override
  State<NearestFilterChip> createState() => _NearestFilterChipState();
}

class _NearestFilterChipState extends State<NearestFilterChip> {
  bool isNearestSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        "Nearest",
        style: AppStyles.semiBold15(context).copyWith(
          color: isNearestSelected
              ? context.theme.white100_1
              : context.theme.blue100_8,
        ),
      ),
      backgroundColor: context.theme.white100_1,
      selectedColor: context.theme.blue100_6,
      checkmarkColor: context.theme.white100_1,
      selected: isNearestSelected,
      onSelected: (bool selected) {
        setState(() {
          isNearestSelected = selected;
        });
      },
    );
  }
}
