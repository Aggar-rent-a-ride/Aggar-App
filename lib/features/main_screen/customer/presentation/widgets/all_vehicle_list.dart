import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/all_vehicles_category_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/most_rented_vehicles_category_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/popular_vehicles_category_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_all_vehicle.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_category_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllVehicleList extends StatelessWidget {
  final String accessToken;

  const AllVehicleList({required this.accessToken, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleCubit()
        ..fetchAllVehicles(accessToken)
        ..fetchPopularVehicles(accessToken)
        ..fetchMostRentedVehicles(accessToken),
      child: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          final cubit = context.read<VehicleCubit>();
          if (state is VehicleLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: LoadingAllVehicle(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VehicleCategorySection(
                    title: 'Most Rented Vehicles',
                    vehicles: cubit.mostRentedVehicles,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MostRentedVehiclesCategoryScreen(
                            accessToken: accessToken,
                          ),
                        ),
                      );
                    },
                  ),
                  VehicleCategorySection(
                    title: 'Popular Vehicles',
                    vehicles: cubit.popularVehicles,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PopularVehiclesCategoryScreen(
                            accessToken: accessToken,
                          ),
                        ),
                      );
                    },
                  ),
                  VehicleCategorySection(
                    title: 'All Vehicles',
                    vehicles: cubit.allVehicles,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllVehiclesCategoryScreen(
                            accessToken: accessToken,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
