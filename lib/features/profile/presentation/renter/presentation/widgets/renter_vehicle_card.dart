import 'package:aggar/core/api/end_points.dart' show EndPoint;
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';

import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicle_car_card_price.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card_car_type.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card_name_with_rating.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/views/vehicle_details_after_adding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class RenterVehicleCard extends StatelessWidget {
  final String carName;
  final String carType;
  final double pricePerHour;
  final double? rating;
  final String assetImagePath;
  final String vehicleId;

  const RenterVehicleCard({
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

    return GestureDetector(
      onTap: () async {
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
                    style: AppStyles.medium16(context).copyWith(
                      color: AppConstants.myWhite100_1,
                    ),
                  ),
                ],
              ),
            );
          },
        );

        try {
          final tokenCubit = context.read<TokenRefreshCubit>();
          final token = await tokenCubit.ensureValidToken();
          if (token != null) {
            await context
                .read<AddVehicleCubit>()
                .getData(vehicleId, token)
                .timeout(const Duration(seconds: 5));

            if (!context.mounted) return;
            Navigator.of(context).pop();

            final vehicleData = context.read<AddVehicleCubit>().vehicleData;
            if (vehicleData != null) {
              if (vehicleData.id.toString() == vehicleId.toString()) {
                context.read<ReviewCubit>().getVehicleReviews(vehicleId, token);
                context
                    .read<ReviewCountCubit>()
                    .getVehicleReviewsNumber(vehicleId, token);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailsAfterAddingScreen(
                      discountList: vehicleData.discounts,
                      vehicleRate: vehicleData.rate,
                      vehicleId: vehicleData.id.toString(),
                      vehiceSeatsNo: vehicleData.numOfPassengers.toString(),
                      renterName: vehicleData.renter?.name ?? "Unknown",
                      yearOfManufaction: vehicleData.year,
                      vehicleModel: vehicleData.model,
                      vehicleRentPrice: vehicleData.pricePerDay,
                      vehicleColor: vehicleData.color,
                      vehicleOverView: vehicleData.extraDetails ?? "",
                      images: vehicleData.vehicleImages,
                      mainImage: vehicleData.mainImagePath,
                      vehicleHealth: vehicleData.physicalStatus == "Excellent"
                          ? "excellent"
                          : vehicleData.physicalStatus == "Good"
                              ? "good"
                              : vehicleData.physicalStatus == "Scratched"
                                  ? "minor dents"
                                  : "not bad",
                      vehicleStatus: vehicleData.status == "OutOfService"
                          ? "out of stock"
                          : "active",
                      transmissionMode: vehicleData.transmission == "Automatic"
                          ? 1
                          : vehicleData.transmission == "None"
                              ? 0
                              : 2,
                      vehicleType: vehicleData.vehicleType.name,
                      vehicleBrand: vehicleData.vehicleBrand.name,
                      vehicleAddress: vehicleData.address,
                      vehicleLongitude:
                          vehicleData.location.longitude as double,
                      vehicleLatitude: vehicleData.location.latitude as double,
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
  }
}
