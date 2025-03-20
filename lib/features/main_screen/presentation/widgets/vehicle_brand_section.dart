import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brands",
          style: AppStyles.bold24(context).copyWith(
            color: AppLightColors.myBlue100_5,
          ),
        ),
        const Gap(5),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              VehicleBrandCard(
                imgPrv: AppAssets.assetsImagesTesla,
                label: "Tesla",
                numOfBrands: 8,
              ),
              VehicleBrandCard(
                imgPrv: AppAssets.assetsImagesTesla,
                label: "Tesla",
                numOfBrands: 9,
              ),
              VehicleBrandCard(
                imgPrv: AppAssets.assetsImagesTesla,
                label: "Tesla",
                numOfBrands: 1800,
              ),
              VehicleBrandCard(
                imgPrv: AppAssets.assetsImagesTesla,
                label: "Tesla",
                numOfBrands: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
