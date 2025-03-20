import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';
import 'popular_vehicles_car_card.dart';

class PopularVehiclesSection extends StatelessWidget {
  const PopularVehiclesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Popular vehicles',
              style: AppStyles.bold24(context).copyWith(
                color: AppLightColors.myBlue100_5,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'see all',
                    style: AppStyles.medium15(context).copyWith(
                      color: AppLightColors.myBlue100_2,
                    ),
                  ),
                  const Gap(5),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppLightColors.myBlue100_2,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(5),
        const PopularVehiclesCarCard(
          carName: 'Tesla Model S',
          carType: 'SUV-automatic',
          pricePerHour: '120',
          rating: 4.8,
          assetImagePath: AppAssets.assetsImagesCar,
        ),
        const PopularVehiclesCarCard(
          carName: 'Tesla Model S',
          carType: 'SUV-automatic',
          pricePerHour: '120',
          rating: 4.8,
          assetImagePath: AppAssets.assetsImagesCar,
        ),
        const PopularVehiclesCarCard(
          carName: 'Tesla Model S',
          carType: 'SUV-automatic',
          pricePerHour: '120',
          rating: 4.8,
          assetImagePath: AppAssets.assetsImagesCar,
        ),
      ],
    );
  }
}
