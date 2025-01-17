import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'car_card.dart';

class PopularVehiclesSection extends StatelessWidget {
  const PopularVehiclesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular vehicles',
              style: TextStyle(
                color: AppColors.myBlue100_1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'see all',
                    style: TextStyle(color: AppColors.myBlue100_2),
                  ),
                  const Gap(5),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColors.myBlue100_2, size: 12),
                ],
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return const CarCard(
              carName: 'Tesla Model S',
              carType: 'SUV-automatic',
              pricePerHour: '120',
              rating: 4.8,
              assetImagePath: AppAssets.assetsImagesCar,
            );
          },
        ),
      ],
    );
  }
}
