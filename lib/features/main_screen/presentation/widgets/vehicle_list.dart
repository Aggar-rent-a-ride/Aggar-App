import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card.dart';
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
        if (state is VehicleLoaded) {
          return Column(
            children: List.generate(
              state.vehicles.data.length,
              (index) => PopularVehiclesCarCard(
//
                vehicleId: state.vehicles.data[index].id.toString(),
                carName:
                    "${state.vehicles.data[index].brand} ${state.vehicles.data[index].model}",
                carType: state.vehicles.data[index].transmission,
                pricePerHour: state.vehicles.data[index].pricePerDay,
                rating: state.vehicles.data[index].rate ?? 5.0,
                assetImagePath: state.vehicles.data[index].mainImagePath,
              ),
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: context.theme.gray100_1,
            highlightColor: context.theme.white100_1,
            child: Column(
              spacing: 15,
              children: List.generate(
                3,
                (index) => Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
