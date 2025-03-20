import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_color_and_seats_num_fields.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/properites_over_view_field.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/transmission_mode_options.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_health_options.dart';
import 'package:flutter/material.dart';

class VehicleProperitesSection extends StatefulWidget {
  const VehicleProperitesSection({
    super.key,
    required this.vehicleColorController,
    required this.vehicleSeatsNoController,
    required this.vehicleOverviewController,
  });
  final TextEditingController vehicleColorController;
  final TextEditingController vehicleSeatsNoController;
  final TextEditingController vehicleOverviewController;
  @override
  State<VehicleProperitesSection> createState() =>
      _VehicleProperitesSectionState();
}

class _VehicleProperitesSectionState extends State<VehicleProperitesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Properties : ",
          style: AppStyles.bold22(context).copyWith(
            color: AppLightColors.myBlue100_2,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            PickColorAndSeatsNumFields(
              vehicleColorController: widget.vehicleColorController,
              vehicleSeatsNoController: widget.vehicleSeatsNoController,
            ),
            ProperitesOverViewField(
              vehicleOverviewController: widget.vehicleOverviewController,
            ),
            const VehicleHealthOptions(),
            const TransmissionModeOptions(),
          ],
        )
      ],
    );
  }
}
