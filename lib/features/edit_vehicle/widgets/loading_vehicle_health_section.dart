import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/edit_vehicle/widgets/loading_vehicle_health_buttons.dart';
import 'package:flutter/material.dart';

class LoadingVehicleHealthSection extends StatelessWidget {
  const LoadingVehicleHealthSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
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
            LoadingVehicleHealthButtons(),
            LoadingVehicleHealthButtons(),
          ],
        ),
        const Row(
          spacing: 15,
          children: [
            LoadingVehicleHealthButtons(),
            LoadingVehicleHealthButtons(),
          ],
        ),
      ],
    );
  }
}
