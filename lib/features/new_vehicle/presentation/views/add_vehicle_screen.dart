// ignore_for_file: use_build_context_synchronously

import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/discount/presentation/views/discount_screen.dart';
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
  String? _accessToken;
  bool isLoading = true;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    if (_isFirstBuild) {
      _resetAllState();
      _isFirstBuild = false;
    }
    _loadToken();
  }

  void _resetAllState() {
    // Reset AddVehicleCubit state
    final addVehicleCubit = context.read<AddVehicleCubit>();
    final mainImageCubit = context.read<MainImageCubit>();
    final additionalImagesCubit = context.read<AdditionalImageCubit>();

    mainImageCubit.reset();
    additionalImagesCubit.reset();
    addVehicleCubit.reset();

    // Reset form controllers
    addVehicleCubit.vehicleModelController.clear();
    addVehicleCubit.vehicleRentalPrice.clear();
    addVehicleCubit.vehicleYearOfManufactureController.clear();
    addVehicleCubit.vehicleColorController.clear();
    addVehicleCubit.vehicleSeatsNoController.clear();
    addVehicleCubit.vehicleProperitesOverviewController.clear();
    addVehicleCubit.vehicleBrandController.clear();
    addVehicleCubit.vehicleTypeController.clear();
    addVehicleCubit.vehicleStatusController.clear();
    addVehicleCubit.vehicleAddressController.clear();

    // Reset other state values
    addVehicleCubit.selectedTransmissionModeValue = 0;
    addVehicleCubit.selectedVehicleBrandValue = null;
    addVehicleCubit.selectedVehicleTypeValue = null;
    addVehicleCubit.selectedVehicleStatusValue = null;
    addVehicleCubit.selectedVehicleBrandId = null;
    addVehicleCubit.selectedVehicleTypeId = null;
    addVehicleCubit.selectedVehicleHealthValue = null;

    // Reset MapLocationCubit
    context.read<MapLocationCubit>().reset();

    // Reset MainImageCubit
    context.read<MainImageCubit>().reset();

    // Reset AdditionalImageCubit
    context.read<AdditionalImageCubit>().reset();
  }

  Future<void> _loadToken() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();

    if (token != null) {
      setState(() {
        _accessToken = token;
        isLoading = false;
      });
      await _fetchInitialData(token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Error",
          "Failed to get authentication token",
          SnackBarType.error,
        ),
      );
    }
  }

  Future<void> _fetchInitialData(String token) async {
    await Future.wait([
      context.read<VehicleBrandCubit>().fetchVehicleBrands(token),
      context.read<VehicleTypeCubit>().fetchVehicleTypes(token),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddVehicleCubit, AddVehicleState>(
      listener: (context, state) {
        if (state is AddVehicleSuccess) {
          context.read<AddVehicleCubit>().getResponseData();
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              "Vehicle added successfully!",
              SnackBarType.success,
            ),
          );
        } else if (state is AddVehicleFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              state.message,
              SnackBarType.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBarContent(
            color: context.theme.blue100_1,
            title: "Add Vehicle",
            onPressed: () async {
              if (_accessToken == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "Authentication token not available. Please try again.",
                    SnackBarType.error,
                  ),
                );
                return;
              }
              final mapLocationCubit = context.read<MapLocationCubit>();
              if (context
                      .read<AddVehicleCubit>()
                      .addVehicleFormKey
                      .currentState
                      ?.validate() ??
                  false) {
                if (mapLocationCubit.selectedLocation == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Warning",
                      "Please select a location on the map",
                      SnackBarType.warning,
                    ),
                  );
                  return;
                }
                await context.read<AddVehicleCubit>().postData(
                      token: _accessToken!,
                      additionalImages:
                          context.read<AdditionalImageCubit>().images,
                      location: mapLocationCubit.selectedLocation!,
                      mainImageFile: context.read<MainImageCubit>().image!,
                    );
                if (context.read<AddVehicleCubit>().state
                    is AddVehicleSuccess) {
                  final vehicleId =
                      context.read<AddVehicleCubit>().getVehicleId();

                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DiscountScreenView(vehicleId: vehicleId.toString()),
                    ),
                  );
                }
              }
            },
          ),
          backgroundColor: context.theme.white100_1,
          appBar: AppBar(
            elevation: 2,
            shadowColor: Colors.grey[900],
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
            backgroundColor: context.theme.white100_1,
            title: Text(
              'Add Vehicle',
              style: AppStyles.semiBold24(context)
                  .copyWith(color: context.theme.black100),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: context.read<AddVehicleCubit>().addVehicleFormKey,
                    child: Column(
                      children: [
                        const Gap(25),
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
                          vehicleTypeController: context
                              .read<AddVehicleCubit>()
                              .vehicleTypeController,
                        ),
                        const Gap(25),
                        VehicleImagesSection(
                          initialMainImagesUrl:
                              context.read<AdditionalImageCubit>().imagesUrl,
                          initialMainImageUrl:
                              context.read<MainImageCubit>().imageUrl,
                        ),
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
                          onLocationSelected:
                              (LatLng location, String address) {
                            context
                                .read<MapLocationCubit>()
                                .updateSelectedLocation(location);
                          },
                        ),
                        const Gap(25),
                        VehicleRentalPriceSection(
                          isEditing: true,
                          vehicleRentalPrice: context
                              .read<AddVehicleCubit>()
                              .vehicleRentalPrice,
                          vehicleStatusController: context
                              .read<AddVehicleCubit>()
                              .vehicleStatusController,
                        ),
                        const Gap(35),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AddVehicleLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
