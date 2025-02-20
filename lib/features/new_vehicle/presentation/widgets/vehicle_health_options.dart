import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_health_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleHealthOptions extends StatelessWidget {
  const VehicleHealthOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "vehicle health",
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        const Gap(10),
        const Row(
          spacing: 25,
          children: [
            Column(
              spacing: 25,
              children: [
                VehicleHealthButton(
                  text: 'Excellent',
                ),
                VehicleHealthButton(
                  text: 'Minor dents',
                ),
              ],
            ),
            Column(
              spacing: 25,
              children: [
                VehicleHealthButton(
                  text: 'Good',
                ),
                VehicleHealthButton(
                  text: 'Not bad',
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
