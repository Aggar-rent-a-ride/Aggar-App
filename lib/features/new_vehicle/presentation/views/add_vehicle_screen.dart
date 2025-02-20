import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_images_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_properites_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

import '../widgets/about_vehicle_section.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        backgroundColor: AppColors.myWhite100_1,
        title: Text(
          'Add Vehicle',
          style: AppStyles.semiBold24(context),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              AboutVehicleSection(),
              Gap(25),
              VehicleImagesSection(),
              Gap(25),
              VehicleProperitesSection()
            ],
          ),
        ),
      ),
    );
  }
}
