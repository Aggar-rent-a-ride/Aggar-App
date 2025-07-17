import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_state.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/views/favorite_vehicle_screen.dart';
import 'package:aggar/features/profile/presentation/renter/presentation/widgets/vehicle_card.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/vehicles_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class SavedVehicleSection extends StatelessWidget {
  const SavedVehicleSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SpinKitThreeBounce(
                color: AppConstants.myWhite100_1,
                size: 30.0,
              ),
            ),
          );
        } else if (state is ProfileGetFavoriteSuccess) {
          final vehicles = state.listVehicleModel.data.take(10).toList();
          if (vehicles.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite,
                        size: 50, color: context.theme.blue100_2),
                    const SizedBox(height: 10),
                    Text(
                      'No saved vehicles yet',
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.black50,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: vehicles
                      .asMap()
                      .entries
                      .take(6)
                      .map(
                        (entry) => VehicleCard(
                          entry: entry,
                          onTap: isLoading
                              ? null
                              : () async {
                                  if (isLoading) return;
                                  isLoading = true;
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SpinKitThreeBounce(
                                              color: AppConstants.myWhite100_1,
                                              size: 30.0,
                                            ),
                                            const Gap(10),
                                            Text(
                                              "Loading vehicle details...",
                                              style: AppStyles.medium16(context)
                                                  .copyWith(
                                                color:
                                                    AppConstants.myWhite100_1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  try {
                                    final tokenCubit =
                                        context.read<TokenRefreshCubit>();
                                    final token =
                                        await tokenCubit.ensureValidToken();
                                    if (token != null) {
                                      await context
                                          .read<AddVehicleCubit>()
                                          .getData(
                                              entry.value.id.toString(), token)
                                          .timeout(const Duration(seconds: 5));

                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();

                                      final vehicle = context
                                          .read<AddVehicleCubit>()
                                          .vehicleData;
                                      if (vehicle != null) {
                                        context
                                            .read<ReviewCubit>()
                                            .getVehicleReviews(
                                                entry.value.id.toString(),
                                                token);
                                        context
                                            .read<ReviewCountCubit>()
                                            .getVehicleReviewsNumber(
                                                entry.value.id.toString(),
                                                token);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VehiclesDetailsView(
                                              isFavorite: vehicle.isFavorite,
                                              renterId: vehicle.renter!.id,
                                              vehicleRate: vehicle.rate,
                                              images: vehicle.vehicleImages,
                                              mainImage: vehicle.mainImagePath,
                                              renterName:
                                                  vehicle.renter?.name ?? "",
                                              transmissionMode:
                                                  vehicle.transmission ==
                                                          "Automatic"
                                                      ? 1
                                                      : vehicle.transmission ==
                                                              "None"
                                                          ? 0
                                                          : 2,
                                              vehiceSeatsNo: vehicle
                                                  .numOfPassengers
                                                  .toString(),
                                              vehicleAddress: vehicle.address,
                                              vehicleBrand:
                                                  vehicle.vehicleBrand.name,
                                              vehicleColor: vehicle.color,
                                              vehicleHealth: vehicle
                                                          .physicalStatus ==
                                                      "Excellent"
                                                  ? "excellent"
                                                  : vehicle.physicalStatus ==
                                                          "Good"
                                                      ? "good"
                                                      : vehicle.physicalStatus ==
                                                              "Scratched"
                                                          ? "minor dents"
                                                          : "not bad",
                                              vehicleId: vehicle.id,
                                              vehicleLatitude: vehicle
                                                  .location.latitude
                                                  .toDouble(),
                                              vehicleLongitude: vehicle
                                                  .location.longitude
                                                  .toDouble(),
                                              vehicleModel: vehicle.model,
                                              vehicleOverView:
                                                  vehicle.extraDetails ?? "",
                                              vehicleRentPrice:
                                                  vehicle.pricePerDay,
                                              vehicleStatus: vehicle.status ==
                                                      "OutOfService"
                                                  ? "out of stock"
                                                  : "active",
                                              vehicleType:
                                                  vehicle.vehicleType.name,
                                              yearOfManufaction: vehicle.year,
                                              pfpImage:
                                                  vehicle.renter?.imagePath,
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            customSnackBar(
                                              context,
                                              "Error",
                                              "Failed to fetch vehicle details",
                                              SnackBarType.error,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar(
                                          context,
                                          "Error",
                                          "Failed to load vehicle details: $e",
                                          SnackBarType.error,
                                        ),
                                      );
                                    }
                                  } finally {
                                    isLoading = false;
                                  }
                                },
                        ),
                      )
                      .toList(),
                ),
                if (vehicles.length >= 6)
                  SeeMoreButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoriteVehicleScreen(),
                        ),
                      );
                    },
                  )
              ],
            ),
          );
        } else if (state is ProfileError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 50,
                    color: context.theme.blue100_2,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Something was wrong',
                    style: AppStyles.medium16(context).copyWith(
                      color: context.theme.black50,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 50, color: context.theme.blue100_2),
                const SizedBox(height: 10),
                Text(
                  'No saved vehicles yet',
                  style: AppStyles.medium16(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
