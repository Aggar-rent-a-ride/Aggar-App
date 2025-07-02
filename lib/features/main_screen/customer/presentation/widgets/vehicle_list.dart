import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoaded || state is VehicleLoadingMore) {
          final vehicles = state is VehicleLoaded
              ? state.vehicles.data
              : (state as VehicleLoadingMore).vehicles.data;
          return Column(
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vehicles.length,
                itemBuilder: (context, index) => PopularVehiclesCarCard(
                  vehicleId: vehicles[index].id.toString(),
                  carName: "${vehicles[index].brand} ${vehicles[index].model}",
                  carType: vehicles[index].transmission,
                  pricePerHour: vehicles[index].pricePerDay,
                  rating: vehicles[index].rate,
                  assetImagePath: vehicles[index].mainImagePath,
                ),
              ),
              if (state is VehicleLoadingMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(
                    color: context.theme.blue100_5,
                  ),
                ),
            ],
          );
        } else {
          return Shimmer.fromColors(
            baseColor: context.theme.grey100_1,
            highlightColor: context.theme.white100_1,
            child: Column(
              children: List.generate(
                3,
                (index) => Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.only(bottom: 15),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
