import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_app_bar.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/over_view_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            const CustomAppBar(),
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
                const OverViewSection()
              ],
            )
          ],
        ),
      ),
    );
  }
}
