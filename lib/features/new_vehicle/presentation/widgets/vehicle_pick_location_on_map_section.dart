import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_location_on_map_button.dart';
import 'package:flutter/material.dart';

class VehiclePickLocationOnMapSection extends StatelessWidget {
  const VehiclePickLocationOnMapSection({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "vehicle location",
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        PickLocationOnMapButton(onPressed: onPressed),
      ],
    );
  }
}
