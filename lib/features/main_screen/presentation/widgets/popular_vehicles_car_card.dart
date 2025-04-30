import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicle_car_card_price.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card_car_type.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card_name_with_rating.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_state.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/views/vehicle_details_after_adding_screen.dart';
import 'package:aggar/core/cubit/refresh token/token_refresh_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';

class PopularVehiclesCarCard extends StatelessWidget {
  final String carName;
  final String carType;
  final String pricePerHour;
  final double rating;
  final String assetImagePath;

  const PopularVehiclesCarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.pricePerHour,
    required this.rating,
    required this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddVehicleCubit, AddVehicleState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            print("heeeeeeer");
            final token =
                await context.read<TokenRefreshCubit>().getAccessToken();
            if (token != null) {
              context.read<AddVehicleCubit>().getData("15", token);
              context.read<ReviewCubit>().getVehicleReviews("15", token);
            }
            if (context.read<AddVehicleCubit>().vehicleData != null) {
              final vehicle = context.read<AddVehicleCubit>().vehicleData!;
              // TODO : here will change the navigator
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleDetailsAfterAddingScreen(
                    renterName: vehicle.renter!.name,
                    yearOfManufaction: vehicle.year,
                    vehicleModel: vehicle.model,
                    vehicleRentPrice: vehicle.pricePerDay,
                    vehicleColor: vehicle.color,
                    vehicleOverView: vehicle.extraDetails ?? "",
                    vehiceSeatsNo: vehicle.numOfPassengers.toString(),
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
              );
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
                        PopularVehicleCarCardPrice(pricePerHour: pricePerHour),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    assetImagePath,
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
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
