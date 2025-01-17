import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_type_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehiclesTypeSection extends StatelessWidget {
  const VehiclesTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicles Type",
          style: TextStyle(
            color: AppColors.myBlue100_1,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              vehicleTypeIcon(AppAssets.assetsIconsCarIcon, "Cars"),
              vehicleTypeIcon(AppAssets.assetsIconsTruckIcon, "Trucks"),
              vehicleTypeIcon(
                  AppAssets.assetsIconsMotorcyclesIcon, "Motorcycles"),
              vehicleTypeIcon(
                  AppAssets.assetsIconsRecreationalIcon, "Recreational"),
            ],
          ),
        ),
      ],
    );
  }
}
