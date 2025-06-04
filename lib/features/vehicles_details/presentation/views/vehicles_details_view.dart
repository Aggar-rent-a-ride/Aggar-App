import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/vehicles_details/presentation/cubit/vehicle_favorite_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/cubit/vehicle_favorite_state.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/bottom_navigation_bar_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/car_name_with_type_and_year_of_manifiction.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/tab_bar_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView({
    super.key,
    required this.vehicleId,
    required this.yearOfManufaction,
    required this.vehicleModel,
    required this.vehicleRentPrice,
    required this.vehicleColor,
    required this.vehicleOverView,
    required this.vehiceSeatsNo,
    required this.images,
    required this.mainImage,
    required this.vehicleHealth,
    required this.vehicleStatus,
    required this.transmissionMode,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleAddress,
    required this.vehicleLongitude,
    required this.vehicleLatitude,
    this.pfpImage,
    required this.renterName,
  });

  final int vehicleId;
  final int yearOfManufaction;
  final String vehicleModel;
  final double vehicleRentPrice;
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;
  final List<String?> images;
  final String mainImage;
  final String vehicleHealth;
  final String vehicleStatus;
  final int transmissionMode;
  final String vehicleType;
  final String vehicleBrand;
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final String? pfpImage;
  final String renterName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleFavoriteCubit(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            shadowColor: Colors.grey[900],
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: context.theme.white100_1,
            actions: [
              BlocConsumer<VehicleFavoriteCubit, VehicleFavoriteState>(
                listener: (context, state) {
                  if (state is VehicleFavoriteSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text(state.response['message'] ?? 'Success')),
                    );
                  } else if (state is VehicleFavoriteFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return IconButton(
                    onPressed: state is XVehicleFavoriteLoading
                        ? null
                        : () {
                            context.read<VehicleFavoriteCubit>().toggleFavorite(
                                vehicleId,
                                !state.isFavorite,
                                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMiIsImp0aSI6ImE5NGU4NTIzLWFkNDMtNGQ0MC1hOWEwLWVkYmY0MTVhZmMyNSIsInVzZXJuYW1lIjoiQ3VzdG9tZXIiLCJ1aWQiOiIyMiIsInJvbGVzIjpbIlVzZXIiLCJDdXN0b21lciJdLCJleHAiOjE3NDg5ODU2ODcsImlzcyI6IkFnZ2FyQXBpIiwiYXVkIjoiRmx1dHRlciJ9.SevWYP3lZyP9pgbXI5VKixkBo4L8tPsXELwbSa4bDSM");
                          },
                    icon: state is XVehicleFavoriteLoading
                        ? const CircularProgressIndicator()
                        : Icon(
                            state.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: state.isFavorite ? Colors.red : null,
                          ),
                  );
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.theme.black100,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Vehicle Details',
              style: AppStyles.semiBold24(context)
                  .copyWith(color: context.theme.black100),
            ),
          ),
          backgroundColor: context.theme.white100_1,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImageCar(
                        mainImage: mainImage,
                      ),
                      CarNameWithTypeAndYearOfManifiction(
                        carName: '$vehicleBrand $vehicleModel',
                        manifactionYear: yearOfManufaction,
                        transmissionType: transmissionMode,
                      ),
                      TabBarSection(
                        vehilceType: vehicleType,
                        pfpImage: pfpImage,
                        renterName: renterName,
                        vehicleColor: vehicleColor,
                        vehicleOverView: vehicleOverView,
                        vehiceSeatsNo: vehiceSeatsNo,
                        images: images,
                        mainImage: mainImage,
                        vehicleHealth: vehicleHealth,
                        vehicleStatus: vehicleStatus,
                        vehicleAddress: vehicleAddress,
                        vehicleLongitude: vehicleLongitude,
                        vehicleLatitude: vehicleLatitude,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBarSection(
            price: vehicleRentPrice,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
