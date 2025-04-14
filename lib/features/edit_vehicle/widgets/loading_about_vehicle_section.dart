import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/edit_vehicle/widgets/loading_field.dart';
import 'package:flutter/material.dart';

class LoadingAboutVehicleSection extends StatelessWidget {
  const LoadingAboutVehicleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Container(
          height: 25,
          width: 140,
          decoration: BoxDecoration(
            color: AppLightColors.myWhite100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Row(
          spacing: 15,
          children: [
            LoadingField(),
            LoadingField(),
          ],
        ),
        const Row(
          spacing: 15,
          children: [
            LoadingField(),
            LoadingField(),
          ],
        ),
      ],
    );
  }
}
