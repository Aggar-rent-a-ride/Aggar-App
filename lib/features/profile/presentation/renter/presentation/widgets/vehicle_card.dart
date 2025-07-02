import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/data/model/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.entry,
    this.onTap,
  });
  final MapEntry<int, VehicleModel> entry;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.5,
        color: context.theme.white100_1,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              "${EndPoint.baseUrl}${entry.value.mainImagePath}",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Iconsax.warning_2,
                color: context.theme.blue100_1,
              ),
            ),
          ),
          title: Text(
            '${entry.value.brand} ${entry.value.model}',
            style: AppStyles.bold16(context),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${entry.value.year} • ${entry.value.transmission}',
                style: AppStyles.medium14(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
              Text(
                '\$${entry.value.pricePerDay.toStringAsFixed(2)}/day',
                style: AppStyles.medium14(context).copyWith(
                  color: context.theme.blue100_2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
