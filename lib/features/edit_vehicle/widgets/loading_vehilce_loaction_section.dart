import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/edit_vehicle/widgets/loading_field.dart';
import 'package:aggar/features/edit_vehicle/widgets/loading_vehilce_map_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingVehilceLoactionSection extends StatelessWidget {
  const LoadingVehilceLoactionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const Gap(15),
        const Row(
          children: [
            LoadingField(),
          ],
        ),
        const Gap(15),
        const LoadingVehilceMapSection()
      ],
    );
  }
}
