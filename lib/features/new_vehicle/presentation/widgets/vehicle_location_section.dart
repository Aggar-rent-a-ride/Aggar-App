import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_pick_location_on_map_section.dart';
import 'package:flutter/material.dart';

class VehicleLocationSection extends StatelessWidget {
  const VehicleLocationSection({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Location :",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        const InputNameWithInputFieldSection(
          width: double.infinity,
          label: "vehicle address",
          hintText: "Minya al-Qamh,  Sharkia,  Egypt",
        ),
        VehiclePickLocationOnMapSection(onPressed: onPressed),
      ],
    );
  }
}
