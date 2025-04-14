import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingVehicleImageSection extends StatelessWidget {
  const LoadingVehicleImageSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppLightColors.myWhite100_1,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Gap(15),
        Container(
          height: 25,
          width: 140,
          decoration: BoxDecoration(
            color: AppLightColors.myWhite100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Gap(15),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
