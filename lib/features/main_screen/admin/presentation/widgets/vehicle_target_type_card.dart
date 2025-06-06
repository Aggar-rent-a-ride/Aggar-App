import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/price_with_transmission_with_distance_row.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/vehilce_image_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleTargetTypeCard extends StatelessWidget {
  const VehicleTargetTypeCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.year,
    required this.model,
    required this.transmission,
    required this.pricePerDay,
    required this.distance,
  });

  final int id;
  final String imagePath;
  final int year;
  final String model;
  final String transmission;
  final String pricePerDay;
  final num distance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: context.theme.blue10_2,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: VehilceImageSection(imagePath: imagePath, id: id),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$model ($year)",
                    style: AppStyles.bold24(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                  PriceWithTransmissionWithDistanceRow(
                    pricePerDay: pricePerDay,
                    transmission: transmission,
                    distance: distance,
                  ),
                  const Gap(8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
