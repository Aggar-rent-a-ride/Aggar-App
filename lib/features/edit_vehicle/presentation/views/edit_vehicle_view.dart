import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_state.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_edit_vehicle_view_body.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/vehicle_discount_section.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_model.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/about_vehicle_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_images_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_location_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_properites_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_rental_price_section.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';

class EditVehicleView extends StatefulWidget {
  final String vehicleId;

  const EditVehicleView({super.key, required this.vehicleId});

  @override
  State<EditVehicleView> createState() => _EditVehicleViewState();
}

class _EditVehicleViewState extends State<EditVehicleView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tokenRefreshCubit = context.read<TokenRefreshCubit>();
      final token = await tokenRefreshCubit.getAccessToken();
      if (token != null) {
        context
            .read<EditVehicleCubit>()
            .fetchVehicleData(widget.vehicleId, token: token);
        context.read<VehicleBrandCubit>().fetchVehicleBrands(token);
        context.read<VehicleTypeCubit>().fetchVehicleTypes(token);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            "Error",
            "Authentication failed. Please login again.",
            SnackBarType.error,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditVehicleCubit, EditVehicleState>(
      listener: (context, state) async {
        if (state is EditVehicleFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is EditVehicleSuccess) {
          // Refresh the vehicle list in ProfileCubit
          final tokenRefreshCubit = context.read<TokenRefreshCubit>();
          final token = await tokenRefreshCubit.getAccessToken();
          if (token != null) {
            context.read<ProfileCubit>().fetchRenterVehicles(token);
          }
          Navigator.pop(context);
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              "Vehicle updated successfully",
              SnackBarType.success,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is EditVehicleLoading;
        VehicleDataModel? vehicleData =
            state is EditVehicleDataLoaded ? state.vehicleData : null;
        return Scaffold(
          bottomNavigationBar: BottomNavigationBarContent(
            title: "Edit Vehicle",
            onPressed: () async {
              final mapLocationCubit = context.read<MapLocationCubit>();
              final editVehicleCubit = context.read<EditVehicleCubit>();
              if (editVehicleCubit.editVehicleFormKey.currentState
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
                final tokenRefreshCubit = context.read<TokenRefreshCubit>();
                final token = await tokenRefreshCubit.getAccessToken();

                if (token != null) {
                  await editVehicleCubit.updateVehicle(
                    widget.vehicleId,
                    mapLocationCubit.selectedLocation!,
                    context.read<AdditionalImageCubit>().images,
                    context.read<MainImageCubit>().image,
                    context.read<AdditionalImageCubit>().removedImagesUrls,
                    token,
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Error",
                      "Authentication failed. Please login again.",
                      SnackBarType.error,
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
            actions: [
              IconButton(
                onPressed: () async {
                  final tokenRefreshCubit = context.read<TokenRefreshCubit>();
                  final token = await tokenRefreshCubit.getAccessToken();

                  if (token != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          actionTitle: "Delete",
                          title: "Delete vehicle",
                          subtitle:
                              "Are you sure you want to delete this vehicle ?",
                          onPressed: () async {
                            await context
                                .read<EditVehicleCubit>()
                                .deleteVehicle(
                                  widget.vehicleId,
                                  token,
                                );
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar(
                        context,
                        "Error",
                        "Authentication failed. Please login again.",
                        SnackBarType.error,
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: context.theme.black100,
                ),
              ),
              const Gap(20),
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.theme.black100,
              ),
            ),
            backgroundColor: context.theme.white100_1,
            title: Text(
              'Edit Vehicle',
              style: AppStyles.semiBold24(context).copyWith(
                color: context.theme.black100,
              ),
            ),
          ),
          body: isLoading
              ? Shimmer.fromColors(
                  baseColor: context.theme.grey100_1,
                  highlightColor: context.theme.white100_1,
                  child: const LoadingEditVehicleViewBody(),
                )
              : state is EditVehicleFailure
                  ? Shimmer.fromColors(
                      baseColor: context.theme.grey100_1,
                      highlightColor: context.theme.white100_1,
                      child: const LoadingEditVehicleViewBody(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: Form(
                          key: context
                              .read<EditVehicleCubit>()
                              .editVehicleFormKey,
                          child: Column(
                            children: [
                              AboutVehicleSection(
                                isEditing: true,
                                modelController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleModelController,
                                yearOfManufactureController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleYearOfManufactureController,
                                vehicleBrandController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleBrandController,
                                vehicleTypeController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleTypeController,
                                initialVehicleBrand:
                                    vehicleData?.vehicleBrand.name,
                                initialVehicleType:
                                    vehicleData?.vehicleType.name,
                              ),
                              const Gap(25),
                              VehicleImagesSection(
                                initialMainImageUrl:
                                    state is EditVehicleDataLoaded
                                        ? state.vehicleData.mainImagePath
                                        : null,
                                initialMainImagesUrl:
                                    state is EditVehicleDataLoaded
                                        ? state.vehicleData.vehicleImages
                                        : [],
                              ),
                              const Gap(25),
                              VehicleProperitesSection(
                                isEditing: true,
                                initialTransmissionMode:
                                    state is EditVehicleDataLoaded
                                        ? state.vehicleData.transmission
                                        : null,
                                vehicleOverviewController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleProperitesOverviewController,
                                vehicleColorController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleColorController,
                                vehicleSeatsNoController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleSeatsNoController,
                              ),
                              const Gap(25),
                              VehicleLocationSection(
                                initialLocation: state is EditVehicleDataLoaded
                                    ? LatLng(
                                        state.vehicleData.location.latitude
                                            as double,
                                        state.vehicleData.location.longitude
                                            as double,
                                      )
                                    : null,
                                vehicleAddressController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleAddressController,
                                onLocationSelected:
                                    (LatLng location, String address) {
                                  context
                                      .read<MapLocationCubit>()
                                      .updateSelectedLocation(location);
                                  context
                                      .read<EditVehicleCubit>()
                                      .vehicleAddressController
                                      .text = address;
                                },
                              ),
                              const Gap(25),
                              VehicleRentalPriceSection(
                                isEditing: true,
                                vehicleRentalPrice: context
                                    .read<EditVehicleCubit>()
                                    .vehicleRentalPrice,
                                vehicleStatusController: context
                                    .read<EditVehicleCubit>()
                                    .vehicleStatusController,
                                initialVehicleStatus: context
                                    .read<EditVehicleCubit>()
                                    .selectedVehicleStatusValue,
                                onSavedStatus: (value) {
                                  context
                                      .read<EditVehicleCubit>()
                                      .selectedVehicleStatusValue = value;
                                },
                                onStatusChanged: (value, id) {
                                  context
                                      .read<EditVehicleCubit>()
                                      .setVehicleStatus(value);
                                },
                              ),
                              const Gap(25),
                              VehicleDiscountSection(
                                vehicleId: widget.vehicleId,
                                isEditing: true,
                                vehicleData: vehicleData,
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
