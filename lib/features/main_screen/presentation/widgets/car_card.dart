import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CarCard extends StatelessWidget {
  final String carName;
  final String carType;
  final String pricePerHour;
  final double rating;
  final String assetImagePath;

  const CarCard({
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
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Gap(10),
                    Text(
                      carName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, size: 16, color: AppColors.myBlue100_1),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Gap(10),
                    Text(
                      carType,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    const Gap(10),
                    Text(
                      '\$$pricePerHour/hr',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.myBlue100_1,
                      ),
                    ),
                  ],
                ),
              ],
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
