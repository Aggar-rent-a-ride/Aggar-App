import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicle_car_card_price.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card_car_type.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card_name_with_rating.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/vehicles_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import '../../../../new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import '../../../../vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';

class PopularVehiclesCarCard extends StatelessWidget {
  final String carName;
  final String carType;
  final double pricePerHour;
  final double? rating;
  final String assetImagePath;
  final String vehicleId;

  const PopularVehiclesCarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.pricePerHour,
    this.rating,
    required this.assetImagePath,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        if (state is! MainConnected) {
          return Container();
        }

        return GestureDetector(
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
                              color: context.theme.white100_1,
                              size: 30.0,
                            ),
                            const Gap(10),
                            Text(
                              "Loading vehicle details...",
                              style: AppStyles.medium16(context).copyWith(
                                color: context.theme.white100_1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  try {
                    await context
                        .read<AddVehicleCubit>()
                        .getData(vehicleId, state.accessToken)
                        .timeout(const Duration(seconds: 5));

                    if (!context.mounted) return;
                    Navigator.of(context).pop();

                    final vehicleData =
                        context.read<AddVehicleCubit>().vehicleData;
                    if (vehicleData != null) {
                      if (vehicleData.id.toString() == vehicleId.toString()) {
                        context
                            .read<ReviewCubit>()
                            .getVehicleReviews(vehicleId, state.accessToken);
                        context
                            .read<ReviewCountCubit>()
                            .getReviewsNumber(vehicleId, state.accessToken);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehiclesDetailsView(
                              vehicleRate: vehicleData.rate,
                              isFavorite: vehicleData.isFavorite,
                              vehicleId: vehicleData.id,
                              vehiceSeatsNo:
                                  vehicleData.numOfPassengers.toString(),
                              renterName: vehicleData.renter?.name ?? "Unknown",
                              renterId: vehicleData.renter!.id,
                              yearOfManufaction: vehicleData.year,
                              vehicleModel: vehicleData.model,
                              vehicleRentPrice: vehicleData.pricePerDay,
                              vehicleColor: vehicleData.color,
                              vehicleOverView: vehicleData.extraDetails ?? "",
                              images: vehicleData.vehicleImages,
                              mainImage: vehicleData.mainImagePath,
                              vehicleHealth:
                                  vehicleData.physicalStatus == "Excellent"
                                      ? "excellent"
                                      : vehicleData.physicalStatus == "Good"
                                          ? "good"
                                          : vehicleData.physicalStatus ==
                                                  "Scratched"
                                              ? "minor dents"
                                              : "not bad",
                              vehicleStatus:
                                  vehicleData.status == "OutOfService"
                                      ? "out of stock"
                                      : "active",
                              transmissionMode:
                                  vehicleData.transmission == "Automatic"
                                      ? 1
                                      : vehicleData.transmission == "None"
                                          ? 0
                                          : 2,
                              vehicleType: vehicleData.vehicleType.name,
                              vehicleBrand: vehicleData.vehicleBrand.name,
                              vehicleAddress: vehicleData.address,
                              vehicleLongitude:
                                  vehicleData.location.longitude as double,
                              vehicleLatitude:
                                  vehicleData.location.latitude as double,
                            ),
                          ),
                        );
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(
                              context,
                              "Error",
                              "Vehicle data not found",
                              SnackBarType.error,
                            ),
                          );
                        }
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
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
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: context.theme.white100_2,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PopularVehiclesCarCardNameWithRating(
                          carName: carName,
                          rating: rating,
                        ),
                        PopularVehiclesCarCardCarType(carType: carType),
                        PopularVehicleCarCardPrice(
                          pricePerHour: pricePerHour.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    "${EndPoint.baseUrl}$assetImagePath",
                    height: 110,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppAssets.assetsImagesCar,
                        height: 100,
                        width: 150,
                        fit: BoxFit.cover,
                      );
                    },
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
