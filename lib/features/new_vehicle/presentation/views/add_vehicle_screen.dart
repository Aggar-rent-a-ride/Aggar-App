import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_images_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_properites_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_rental_price_section.dart';
import 'package:flutter/material.dart';
import '../widgets/about_vehicle_section.dart';

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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            spacing: 25,
            children: [
              AboutVehicleSection(),
              VehicleImagesSection(),
              VehicleProperitesSection(),
              VehicleRentalPriceSection()
            ],
          ),
        ),
      ),
    );
  }
}
