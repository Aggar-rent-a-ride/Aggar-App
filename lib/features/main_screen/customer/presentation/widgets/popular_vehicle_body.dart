import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/data/model/vehicle_model.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/popular_vehicles_category_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';

class PopularVehicleBody extends StatelessWidget {
  const PopularVehicleBody({
    super.key,
    required this.cubit,
    required this.widget,
    required ScrollController scrollController,
    required this.vehicles,
    required this.canLoadMore,
    required this.isLoadingMore,
  }) : _scrollController = scrollController;

  final VehicleCubit cubit;
  final PopularVehiclesCategoryScreen widget;
  final ScrollController _scrollController;
  final List<VehicleModel> vehicles;
  final bool canLoadMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        cubit.fetchPopularVehicles(widget.accessToken);
      },
      color: context.theme.blue100_8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          controller: _scrollController,
          itemCount: vehicles.length + (canLoadMore || isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == vehicles.length) {
              if (isLoadingMore) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.theme.blue100_8,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            final vehicle = vehicles[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: PopularVehiclesCarCard(
                assetImagePath: vehicle.mainImagePath,
                carName: "${vehicle.brand} ${vehicle.model}",
                carType: vehicle.transmission,
                pricePerHour: vehicle.pricePerDay,
                vehicleId: vehicle.id.toString(),
                rating: vehicle.rate,
              ),
            );
          },
        ),
      ),
    );
  }
}
