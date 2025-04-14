import 'package:aggar/features/edit_vehicle/widgets/loading_about_vehicle_section.dart';
import 'package:aggar/features/edit_vehicle/widgets/loading_vehicle_image_section.dart';
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
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingAboutVehicleSection(),
          Gap(25),
          LoadingVehicleImageSection(),
          Gap(25),
        ],
      ),
    ));
  }
}
