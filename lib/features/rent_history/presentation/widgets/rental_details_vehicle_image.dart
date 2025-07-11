import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';

class RentalDetailsVehicleImage extends StatelessWidget {
  const RentalDetailsVehicleImage({
    super.key,
    required this.rentalItem,
  });

  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.35,
      decoration: BoxDecoration(
        color: context.theme.white100_4,
        borderRadius: BorderRadius.circular(12),
      ),
      // ignore: unnecessary_null_comparison
      child: rentalItem.vehicle.mainImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${EndPoint.baseUrl}${rentalItem.vehicle.mainImagePath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      rentalItem.vehicle.id.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                rentalItem.vehicle.id.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
