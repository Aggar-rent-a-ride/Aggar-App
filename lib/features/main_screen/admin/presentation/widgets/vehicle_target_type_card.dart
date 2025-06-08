import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/price_with_transmission_with_distance_row.dart';
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$model ($year)",
                      style: AppStyles.bold20(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                    const Gap(5),
                    PriceWithTransmissionWithDistanceRow(
                      pricePerDay: pricePerDay,
                      transmission: transmission,
                      distance: distance,
                    ),
                    const Gap(8),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      EndPoint.baseUrl + imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppAssets.assetsImagesCar,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
