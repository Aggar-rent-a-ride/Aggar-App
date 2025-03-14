// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';

import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_images_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_location_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_properites_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_rental_price_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/vehicles_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../widgets/about_vehicle_section.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddVehicleCubit, AddVehicleState>(
      listener: (context, state) {
        if (state is AddVehicleSuccess) {
          print("Sucess");
        } else if (state is AddVehicleFailure) {
          print("Fail");
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBarContent(
            onPressed: () {
              if (context
                      .read<AddVehicleCubit>()
                      .addVehicleFormKey
                      .currentState
                      ?.validate() ??
                  false) {
                String vehicleModel =
                    context.read<AddVehicleCubit>().vehicleModelController.text;
                int vehicleYearOfManufaction = int.parse(context
                    .read<AddVehicleCubit>()
                    .vehicleYearOfManufactureController
                    .text);
                String vehicleColor =
                    context.read<AddVehicleCubit>().vehicleColorController.text;
                String vehicleOverView = context
                    .read<AddVehicleCubit>()
                    .vehicleProperitesOverviewController
                    .text;
                print(vehicleOverView);
                String vehicleSeatsNo = context
                    .read<AddVehicleCubit>()
                    .vehicleSeatsNoController
                    .text;
                List<File?> images =
                    context.read<AdditionalImageCubit>().images;
                File? mainImage = context.read<MainImageCubit>().image!;
                String vehicleHealth =
                    context.read<AddVehicleCubit>().selectedVehicleHealthValue!;
                String vehicleStatus = context
                        .read<AddVehicleCubit>()
                        .selectedVehicleStatusValue ??
                    "jjj";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehiclesDetailsView(
                      yearOfManufaction: vehicleYearOfManufaction,
                      vehicleModel: vehicleModel,
                      vehicleRentPrice: 25,
                      vehicleColor: vehicleColor,
                      vehicleOverView: vehicleOverView,
                      vehiceSeatsNo: vehicleSeatsNo,
                      images: images,
                      mainImage: mainImage,
                      vehicleHealth: vehicleHealth,
                      vehicleStatus: vehicleStatus,
                    ),
                  ),
                );
              }
            },
          ),
          backgroundColor: AppColors.myWhite100_1,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            backgroundColor: AppColors.myWhite100_1,
            title: Text(
              'Add Vehicle',
              style: AppStyles.semiBold24(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: context.read<AddVehicleCubit>().addVehicleFormKey,
                child: Column(
                  spacing: 25,
                  children: [
                    AboutVehicleSection(
                      modelController: context
                          .read<AddVehicleCubit>()
                          .vehicleModelController,
                      yearOfManufactureController: context
                          .read<AddVehicleCubit>()
                          .vehicleYearOfManufactureController,
                    ),
                    const VehicleImagesSection(),
                    VehicleProperitesSection(
                      vehicleOverviewController: context
                          .read<AddVehicleCubit>()
                          .vehicleProperitesOverviewController,
                      vehicleColorController: context
                          .read<AddVehicleCubit>()
                          .vehicleColorController,
                      vehicleSeatsNoController: context
                          .read<AddVehicleCubit>()
                          .vehicleSeatsNoController,
                    ),
                    const VehicleLocationSection(),
                    const VehicleRentalPriceSection(),
                    const Gap(25),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
