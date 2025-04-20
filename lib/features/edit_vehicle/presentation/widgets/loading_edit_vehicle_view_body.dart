import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_about_vehicle_section.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_field.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_seats_no_with_overview_fields.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_transmission_mode_section.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_vehicle_health_section.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_vehicle_image_section.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_vehilce_loaction_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingEditVehicleViewBody extends StatelessWidget {
  const LoadingEditVehicleViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingAboutVehicleSection(),
            Gap(25),
            LoadingVehicleImageSection(),
            Gap(25),
            LoadingSeatsNoWithOverviewFields(),
            Gap(20),
            LoadingVehicleHealthSection(),
            Gap(25),
            LoadingTransmissionModeSection(),
            Gap(20),
            LoadingVehilceLoactionSection(),
            Gap(15),
            Row(
              spacing: 15,
              children: [
                LoadingField(),
                LoadingField(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
