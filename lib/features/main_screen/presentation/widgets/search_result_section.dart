// search_result_section.dart
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SearchResultSection extends StatelessWidget {
  const SearchResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      builder: (context, state) {
        if (state is SearchCubitLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchCubitError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 100, color: Colors.red),
                const Gap(16),
                Text(
                  state.message,
                  style:
                      AppStyles.medium16(context).copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is SearchCubitLoaded) {
          final vehicles = state.vehicles.data;

          if (vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 100, color: Colors.grey),
                  const Gap(16),
                  Text(
                    'No vehicles found',
                    style: AppStyles.medium16(context)
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Results (${vehicles.length} vehicles)',
                  style: AppStyles.medium18(context),
                ),
                const Gap(16),
                Expanded(
                  child: ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return PopularVehiclesCarCard(
                        //
                        vehicleId: vehicle.id.toString(),
                        carName: "${vehicle.brand} ${vehicle.model}",
                        carType: vehicle.transmission,
                        pricePerHour: vehicle.pricePerDay,
                        rating:
                            4.8, // Consider moving this to the vehicle model
                        assetImagePath: vehicle.mainImagePath,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car_outlined,
                  size: 100, color: Colors.grey),
              const Gap(16),
              Text(
                'Search for vehicles',
                style: AppStyles.medium16(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
