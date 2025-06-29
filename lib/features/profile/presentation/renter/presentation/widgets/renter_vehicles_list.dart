import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_state.dart';
import 'package:aggar/features/profile/presentation/renter/presentation/widgets/vehicle_card.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/views/vehicle_details_after_adding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';

class RenterVehiclesList extends StatelessWidget {
  const RenterVehiclesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        print(state);
        if (state is ProfileLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileVehiclesSuccess) {
          final vehicles = state.listVehicleModel.data;
          if (vehicles.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 50, color: context.theme.blue100_2),
                    const SizedBox(height: 10),
                    Text(
                      'No reviews yet',
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.gray100_2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: vehicles
                      .asMap()
                      .entries
                      .map(
                        (entry) => VehicleCard(
                            entry: entry,
                            onTap: () async {
                              const token =
                                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjQzOWUxOTc0LTY1MDctNDM1Zi1iZmI5LTA0MmZkYmEzMmUyMCIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc1MTIzNTY5OSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.6GP6cSvlOQ7JK6dbgq-CQ36B-F5zU9saNi8qviwDkiw";
                              final addVehicleCubit =
                                  context.read<AddVehicleCubit>();
                              showDialog(
                                  context: context,
                                  builder: (_) => const Center(
                                      child: CircularProgressIndicator()),
                                  barrierDismissible: false);

                              await addVehicleCubit.getData(
                                  entry.value.id.toString(), token);
                              await context
                                  .read<ReviewCubit>()
                                  .getVehicleReviews(
                                      entry.value.id.toString(), token);
                              await context
                                  .read<ReviewCountCubit>()
                                  .getVehicleReviewsNumber(
                                      entry.value.id.toString(), token);

                              Navigator.pop(context); // remove loading dialog

                              final vehicle = addVehicleCubit.vehicleData;
                              if (vehicle != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleDetailsAfterAddingScreen(
                                        discountList: vehicle.discounts,
                                        vehicleRate: vehicle.rate,
                                        images: vehicle.vehicleImages,
                                        mainImage: vehicle.mainImagePath,
                                        renterName: vehicle.renter?.name ?? "",
                                        transmissionMode:
                                            vehicle.transmission == "Automatic"
                                                ? 1
                                                : 2,
                                        vehiceSeatsNo:
                                            vehicle.numOfPassengers.toString(),
                                        vehicleAddress: vehicle.address,
                                        vehicleBrand: vehicle.vehicleBrand.name,
                                        vehicleColor: vehicle.color,
                                        vehicleHealth: vehicle.physicalStatus,
                                        vehicleId: vehicle.id.toString(),
                                        vehicleLatitude: vehicle
                                            .location.latitude
                                            .toDouble(),
                                        vehicleLongitude: vehicle
                                            .location.longitude
                                            .toDouble(),
                                        vehicleModel: vehicle.model,
                                        vehicleOverView:
                                            vehicle.extraDetails ?? "",
                                        vehicleRentPrice: vehicle.pricePerDay,
                                        vehicleStatus: vehicle.status,
                                        vehicleType: vehicle.vehicleType.name,
                                        yearOfManufaction: vehicle.year,
                                        pfpImage: vehicle.renter?.imagePath,
                                      ),
                                    ));
                              } else {
                                // Show error
                              }
                            }),
                      )
                      .toList(),
                ),
                SeeMoreButton(
                  onPressed: () {},
                )
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
