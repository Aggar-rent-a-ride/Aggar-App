import 'package:aggar/core/themes/app_light_colors.dart';
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
            color: AppLightColors.myWhite100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppLightColors.myWhite100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppLightColors.myWhite100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
