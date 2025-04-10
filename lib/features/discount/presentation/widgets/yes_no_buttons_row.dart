import 'package:aggar/core/widgets/custom_elevation_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class YesNoButtonsRow extends StatelessWidget {
  const YesNoButtonsRow({
    super.key,
    required this.showDiscount,
    required this.onSelectionChanged,
  });

  final bool showDiscount;
  final Function(bool) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomElevationButton(
          title: "Yes",
          paddingHorizental: 40,
          paddingVertical: 15,
          isSelected: !showDiscount,
          onPressed: () {
            onSelectionChanged(true);
          },
        ),
        const Gap(10),
        CustomElevationButton(
          title: "No",
          paddingHorizental: 40,
          paddingVertical: 15,
          isSelected: showDiscount,
          onPressed: () {
            onSelectionChanged(false);
          },
        ),
      ],
    );
  }
}
