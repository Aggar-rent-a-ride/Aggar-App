// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';

import 'package:aggar/core/themes/app_colors.dart';
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
import 'package:latlong2/latlong.dart';
import '../widgets/about_vehicle_section.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen(
      {super.key, this.initialLocation, this.onLocationSelected});

  final LatLng? initialLocation;
  final Function(LatLng, String)? onLocationSelected;

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  // Store the selected location and address
  LatLng? selectedLocation;
  String selectedAddress = "";

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

  // Handle location selection from VehicleLocationSection
  void _handleLocationSelected(LatLng location, String address) {
    setState(() {
      selectedLocation = location;
      selectedAddress = address;

      // Update the address controller with the selected address
      final addressController =
          context.read<AddVehicleCubit>().vehicleAddressController;
      addressController.text = address;
    });

    // Call the parent's onLocationSelected if provided
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(location, address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddVehicleCubit, AddVehicleState>(
      listener: (context, state) {
        if (state is AddVehicleSuccess) {
          print("Success");
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
                int transmissionMode = context
                        .read<AddVehicleCubit>()
                        .selectedTransmissionModeValue ??
                    0;
                String vehicleRentalPrice =
                    context.read<AddVehicleCubit>().vehicleRentalPrice.text;
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
                String vehicleSeatsNo = context
                    .read<AddVehicleCubit>()
                    .vehicleSeatsNoController
                    .text;
                List<File?> images =
                    context.read<AdditionalImageCubit>().images;
                File? mainImage = context.read<MainImageCubit>().image!;
                String vehicleHealth =
                    context.read<AddVehicleCubit>().selectedVehicleHealthValue!;
                String vehicleType =
                    context.read<AddVehicleCubit>().vehicleTypeController.text;
                String vehicleBrand =
                    context.read<AddVehicleCubit>().vehicleBrandController.text;
                String vehicleStatus = context
                    .read<AddVehicleCubit>()
                    .vehicleStatusController
                    .text;

                // Get the address from the address controller
                String vehicleAddress = context
                    .read<AddVehicleCubit>()
                    .vehicleAddressController
                    .text;

                // Use the stored location or default to 0,0 if not set
                double vehicleLatitude = selectedLocation?.latitude ?? 0.0;
                double vehicleLongitude = selectedLocation?.longitude ?? 0.0;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehiclesDetailsView(
                      initialLocation: selectedLocation,
                      onLocationSelected: _handleLocationSelected,
                      vehicleAddress: vehicleAddress,
                      vehicleLatitude: vehicleLatitude,
                      vehicleLongitude: vehicleLongitude,
                      yearOfManufaction: vehicleYearOfManufaction,
                      vehicleModel: vehicleModel,
                      vehicleRentPrice: double.parse(vehicleRentalPrice),
                      vehicleColor: vehicleColor,
                      vehicleOverView: vehicleOverView,
                      vehiceSeatsNo: vehicleSeatsNo,
                      images: images,
                      mainImage: mainImage,
                      vehicleHealth: vehicleHealth,
                      vehicleStatus: vehicleStatus,
                      transmissionMode: transmissionMode,
                      vehicleType: vehicleType,
                      vehicleBrand: vehicleBrand,
                    ),
                  ),
                );
              }
            },
          ),
          backgroundColor: AppLightColors.myWhite100_1,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            backgroundColor: AppLightColors.myWhite100_1,
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
                  children: [
                    AboutVehicleSection(
                      modelController: context
                          .read<AddVehicleCubit>()
                          .vehicleModelController,
                      yearOfManufactureController: context
                          .read<AddVehicleCubit>()
                          .vehicleYearOfManufactureController,
                      vehicleBrandController: context
                          .read<AddVehicleCubit>()
                          .vehicleBrandController,
                      vehicleTypeController:
                          context.read<AddVehicleCubit>().vehicleTypeController,
                    ),
                    const Gap(25),
                    const VehicleImagesSection(),
                    const Gap(25),
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
                    const Gap(25),
                    VehicleLocationSection(
                      initialLocation: selectedLocation,
                      onLocationSelected: _handleLocationSelected,
                      vehicleAddressController: context
                          .read<AddVehicleCubit>()
                          .vehicleAddressController,
                    ),
                    const Gap(25),
                    VehicleRentalPriceSection(
                      vehicleRentalPrice:
                          context.read<AddVehicleCubit>().vehicleRentalPrice,
                      vehicleStatusController: context
                          .read<AddVehicleCubit>()
                          .vehicleStatusController,
                    ),
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
