import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:aggar/features/rent_history/presentation/widgets/customer_name_with_image.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rental_details_vehicle_image.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rental_details_vehicle_location.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RentalHistoryVehicleDetailsSection extends StatelessWidget {
  const RentalHistoryVehicleDetailsSection({
    super.key,
    required this.statusColor,
    required this.rentalItem,
  });

  final Color statusColor;
  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.theme.white100_2,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 8,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Details',
                        style: AppStyles.bold20(context).copyWith(
                          color: statusColor,
                        ),
                      ),
                      Text(
                        'Rental information',
                        style: AppStyles.regular14(context).copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(20),
            RentalDetailsVehicleImage(rentalItem: rentalItem),
            const Gap(16),
            CustomerNameWithImage(rentalItem: rentalItem),
            const Gap(16),
            RentalDetailsVehicleLocation(rentalItem: rentalItem),
          ],
        ),
      ),
    );
  }
}
