import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_images_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_location_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_properites_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_rental_price_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import '../../data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import '../../data/cubits/main_image_cubit/main_image_cubit.dart';
import '../widgets/about_vehicle_section.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});
  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddVehicleCubit, AddVehicleState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBarContent(
            onPressed: () async {
              // Get the MapLocationCubit instance
              final mapLocationCubit = context.read<MapLocationCubit>();
              print(context
                  .read<AddVehicleCubit>()
                  .selectedTransmissionModeValue);
              print(context.read<AddVehicleCubit>().selectedVehicleHealthValue);

              // Validate the form
              if (context
                      .read<AddVehicleCubit>()
                      .addVehicleFormKey
                      .currentState
                      ?.validate() ??
                  false) {
                // Ensure a location is selected
                if (mapLocationCubit.selectedLocation == null) {
                  // Show an error if no location is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a location on the map'),
                    ),
                  );
                  return;
                }

                // Post data with the selected location
                await context.read<AddVehicleCubit>().postData(
                      additionalImages:
                          context.read<AdditionalImageCubit>().images,
                      location: mapLocationCubit
                          .selectedLocation!, // Ensure location is sent
                      mainImageFile: context.read<MainImageCubit>().image!,
                    );

                // Navigate back after successful submission
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: context.theme.white100_1,
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
                      vehicleAddressController: context
                          .read<AddVehicleCubit>()
                          .vehicleAddressController,
                      onLocationSelected: (LatLng location, String address) {
                        context
                            .read<MapLocationCubit>()
                            .updateSelectedLocation(location);
                      },
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
