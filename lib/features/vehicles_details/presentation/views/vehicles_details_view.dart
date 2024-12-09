import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/book_vehicle_button.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/over_view_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/tab_bar_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.myWhite100_1,
          foregroundColor: AppColors.myWhite100_1,
          shadowColor: AppColors.myWhite100_1,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomIconButton(
                icon: Icons.favorite_border,
                flag: true,
              ),
            ),
          ],
          centerTitle: true,
          title: Text(
            "Vehicles Details",
            style: GoogleFonts.inter(
              color: AppColors.myBlack100,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomIconButton(
              icon: Icons.favorite_border,
              flag: true,
            ),
          ),
        ),
        backgroundColor: AppColors.myWhite100_1,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO : style here want to change
                    Text(
                      "Tesla Model  S",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const CustomImageCar(),
                    const Gap(10),
                    const OverViewSection(),
                    const Gap(20),
                    const TabBarSection()
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BookVehicleButton(),
      ),
    );
  }
}
