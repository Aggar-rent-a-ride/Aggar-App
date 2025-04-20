import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class LoadingVehicleAdditinalImagesSection extends StatelessWidget {
  const LoadingVehicleAdditinalImagesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
