import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_color_and_seats_num_fields.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/properites_over_view_field.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/transmission_mode_options.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_health_options.dart';
import 'package:flutter/material.dart';

class VehicleProperitesSection extends StatefulWidget {
  const VehicleProperitesSection({
    super.key,
  });

  @override
  State<VehicleProperitesSection> createState() =>
      _VehicleProperitesSectionState();
}

class _VehicleProperitesSectionState extends State<VehicleProperitesSection> {
  final int _selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Properties : ",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        Column(
          spacing: 15,
          children: [
            const PickColorAndSeatsNumFields(),
            const ProperitesOverViewField(),
            const VehicleHealthOptions(),
            TransmissionModeOptions(selectedValue: _selectedValue)
          ],
        )
      ],
    );
  }
}
