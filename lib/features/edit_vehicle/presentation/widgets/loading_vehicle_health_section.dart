import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_vehicle_health_buttons.dart';
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
            color: context.theme.white100_1,
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
