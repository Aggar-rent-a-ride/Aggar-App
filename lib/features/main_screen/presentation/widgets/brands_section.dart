import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brands",
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
              vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
              vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
              vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
              vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
            ],
          ),
        ),
      ],
    );
  }
}
