import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_color_and_seats_num_fields.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/properites_over_view_field.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/transmission_mode_options.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_health_options.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleProperitesSection extends StatelessWidget {
  final TextEditingController vehicleColorController;
  final TextEditingController vehicleSeatsNoController;
  final TextEditingController vehicleOverviewController;
  final bool isEditing;
  final String? initialTransmissionMode;

  const VehicleProperitesSection({
    super.key,
    required this.vehicleColorController,
    required this.vehicleSeatsNoController,
    required this.vehicleOverviewController,
    this.isEditing = false,
    this.initialTransmissionMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Properties : ",
          style: AppStyles.bold22(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            PickColorAndSeatsNumFields(
              vehicleColorController: vehicleColorController,
              vehicleSeatsNoController: vehicleSeatsNoController,
            ),
            ProperitesOverViewField(
              vehicleOverviewController: vehicleOverviewController,
            ),
            VehicleHealthOptions(
              isEditing: isEditing,
            ),
            TransmissionModeOptions(
              isEditing: isEditing,
            ),
          ],
        )
      ],
    );
  }
}
