import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_field.dart';
import 'package:flutter/material.dart';

class LoadingAboutVehicleSection extends StatelessWidget {
  const LoadingAboutVehicleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
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
