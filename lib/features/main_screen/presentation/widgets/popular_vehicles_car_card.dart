import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicle_car_card_price.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card_car_type.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card_name_with_rating.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PopularVehiclesCarCard extends StatelessWidget {
  final String carName;
  final String carType;
  final String pricePerHour;
  final double rating;
  final String assetImagePath;

  const PopularVehiclesCarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.pricePerHour,
    required this.rating,
    required this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.myWhite100_1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.myBlack10,
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopularVehiclesCarCardNameWithRating(
                      carName: carName, rating: rating),
                  PopularVehiclesCarCardCarType(carType: carType),
                  const Gap(10),
                  PopularVehicleCarCardPrice(pricePerHour: pricePerHour),
                ],
              ),
            ),
          ),
          const Gap(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              assetImagePath,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
