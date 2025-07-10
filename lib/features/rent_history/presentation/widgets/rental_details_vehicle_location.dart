import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';

class RentalDetailsVehicleLocation extends StatelessWidget {
  const RentalDetailsVehicleLocation({
    super.key,
    required this.rentalItem,
  });

  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location",
          style: AppStyles.semiBold15(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.theme.blue100_1.withOpacity(0.1),
              ),
              child: Icon(
                Icons.location_on,
                size: 25,
                color: context.theme.blue100_1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                rentalItem.vehicle.address,
                style: AppStyles.medium14(context)
                    .copyWith(color: context.theme.black100),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
