import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicle_car_card_price.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card_car_type.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card_name_with_rating.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/vehicles_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';

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
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        if (state is MainConnected) {
          return GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.theme.blue100_2,
                    ),
                  );
                },
              );

              try {
                await context
                    .read<AddVehicleCubit>()
                    .getData(vehicleId, state.accessToken);
                Navigator.of(context).pop();
                final vehicleData = context.read<AddVehicleCubit>().vehicleData;
                await context
                    .read<ReviewCubit>()
                    .getVehicleReviews(vehicleId, state.accessToken);
                if (vehicleData != null) {
                  final vehicle = vehicleData;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehiclesDetailsView(
                        isFavorite: vehicle.isFavorite,
                        vehicleId: vehicle.id,
                        vehiceSeatsNo: vehicle.numOfPassengers.toString(),
                        renterName: vehicle.renter!.name,
                        renterId: vehicle.renter!.id,
                        yearOfManufaction: vehicle.year,
                        vehicleModel: vehicle.model,
                        vehicleRentPrice: vehicle.pricePerDay,
                        vehicleColor: vehicle.color,
                        vehicleOverView: vehicle.extraDetails ?? "",
                        images: vehicle.vehicleImages,
                        mainImage: vehicle.mainImagePath,
                        vehicleHealth: vehicle.physicalStatus == "Excellent"
                            ? "excellent"
                            : vehicle.physicalStatus == "Good"
                                ? "good"
                                : vehicle.physicalStatus == "Scratched"
                                    ? "minor dents"
                                    : "not bad",
                        vehicleStatus: vehicle.status == "OutOfService"
                            ? "out of stock"
                            : "active",
                        transmissionMode: vehicle.transmission == "Automatic"
                            ? 1
                            : vehicle.transmission == "None"
                                ? 0
                                : 2,
                        vehicleType: vehicle.vehicleType.name,
                        vehicleBrand: vehicle.vehicleBrand.name,
                        vehicleAddress: vehicle.address,
                        vehicleLongitude: vehicle.location.longitude,
                        vehicleLatitude: vehicle.location.latitude,
                      ),
                    ),
                  ).then((_) {
                    context.read<AddVehicleCubit>().reset();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Error",
                      "Failed to load vehicle details",
                      SnackBarType.error,
                    ),
                  );
                }
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "Error loading vehicle",
                    SnackBarType.error,
                  ),
                );
              }
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PopularVehiclesCarCardNameWithRating(
                                  carName: carName, rating: rating),
                              PopularVehiclesCarCardCarType(carType: carType),
                              const Gap(10),
                              PopularVehicleCarCardPrice(
                                  pricePerHour: pricePerHour.toString()),
                            ],
                          ),
                        ),
                      ),
                      const Gap(5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          "${EndPoint.baseUrl}$assetImagePath",
                          height: 100,
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
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
