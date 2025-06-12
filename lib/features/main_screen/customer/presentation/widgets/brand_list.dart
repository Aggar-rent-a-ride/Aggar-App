import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandList extends StatelessWidget {
  const BrandList({
    super.key,
    required this.state,
  });

  final VehicleLoadedBrand state;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      itemCount: state.vehicles!.data.length +
          (state.vehicles!.totalPages! >
                  context.read<VehicleBrandCubit>().currentPageAll
              ? 1
              : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        if (index == state.vehicles!.data.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final vehicle = state.vehicles!.data[index];
        return PopularVehiclesCarCard(
          vehicleId: vehicle.id.toString(),
          carName: "${vehicle.brand} ${vehicle.model}",
          carType: vehicle.type,
          pricePerHour: vehicle.pricePerDay,
          rating: vehicle.rate,
          assetImagePath: vehicle.mainImagePath,
        );
      },
    );
  }
}
