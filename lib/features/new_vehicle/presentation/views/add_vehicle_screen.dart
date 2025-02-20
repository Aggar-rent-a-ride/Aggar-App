import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_images_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_properites_section.dart';
import 'package:flutter/material.dart';

import '../widgets/about_vehicle_section.dart';
import '../widgets/input_name_with_input_field_section.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarContent(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            spacing: 25,
            children: [
              const AboutVehicleSection(),
              const VehicleImagesSection(),
              const VehicleProperitesSection(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "Vehicle Properties : ",
                    style: AppStyles.bold22(context).copyWith(
                      color: AppColors.myBlue100_2,
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: InputNameWithInputFieldSection(
                          label: "Rental Price per Day ",
                          hintText: "ex: 2200",
                          width: double.infinity,
                          foundIcon: true,
                          widget: RentalPricePerDaySuffixWidget(),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RentalPricePerDaySuffixWidget extends StatelessWidget {
  const RentalPricePerDaySuffixWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: AppColors.myBlack50,
          ),
        ),
      ),
      child: Text(
        r"$$",
        style: AppStyles.medium15(context).copyWith(
          color: AppColors.myBlack50,
        ),
      ),
    );
  }
}
