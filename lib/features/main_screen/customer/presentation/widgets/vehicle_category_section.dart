import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/main_screen/customer/data/model/vehicle_model.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';

class VehicleCategorySection extends StatelessWidget {
  final String title;
  final List<VehicleModel> vehicles;
  final Function(String, bool)? onFavoriteToggle;
  final void Function()? onPressed;
  const VehicleCategorySection({
    required this.title,
    required this.vehicles,
    this.onFavoriteToggle,
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppStyles.bold22(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
            const Spacer(),
            SeeMoreButton(onPressed: onPressed),
          ],
        ),
        if (vehicles.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No vehicles in this category',
              style: AppStyles.regular16(context).copyWith(
                color: context.theme.black100,
              ),
            ),
          )
        else
          ListView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vehicles.length >= 2 ? 2 : vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return PopularVehiclesCarCard(
                carName: '${vehicle.brand} ${vehicle.type}',
                carType: vehicle.transmission,
                pricePerHour: vehicle.pricePerDay,
                assetImagePath: vehicle.mainImagePath,
                vehicleId: vehicle.id.toString(),
                isFavorite: vehicle.isFavourite,
                rating: vehicle.rate ?? 0.0,
              );
            },
          ),
      ],
    );
  }
}
