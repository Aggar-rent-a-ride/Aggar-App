import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/edit_vehicle_cubit.dart';
import 'package:aggar/features/edit_vehicle/edit_vehicle_state.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditVehicleCubit>().fetchVehicleData(widget.vehicleId);
      context.read<VehicleBrandCubit>().fetchVehicleBrands(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiM2RhNzQ0MzYtZDZmNS00MDBiLWFmNjQtMmYyNmI0YThkOWU1IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0Mzg4ODAwNiwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.coSCavP2QOl_A0VKWApHbnYF-tAhMp_asI5loHNjsZA");
      context.read<VehicleTypeCubit>().fetchVehicleTypes(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiM2RhNzQ0MzYtZDZmNS00MDBiLWFmNjQtMmYyNmI0YThkOWU1IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0Mzg4ODAwNiwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.coSCavP2QOl_A0VKWApHbnYF-tAhMp_asI5loHNjsZA");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditVehicleCubit, EditVehicleState>(
      listener: (context, state) {
        if (state is EditVehicleFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is EditVehicleSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle updated successfully')),
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
            onPressed: isLoading
                ? null
                : () async {
                    // Get the MapLocationCubit instance
                    final mapLocationCubit = context.read<MapLocationCubit>();
                    final editVehicleCubit = context.read<EditVehicleCubit>();

                    // Validate the form
                    if (editVehicleCubit.editVehicleFormKey.currentState
                            ?.validate() ??
                        false) {
                      // Ensure a location is selected
                      if (mapLocationCubit.selectedLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please select a location on the map'),
                          ),
                        );
                        return;
                      }
                      await editVehicleCubit.updateVehicle(
                        widget.vehicleId,
                        mapLocationCubit.selectedLocation!,
                        context.read<AdditionalImageCubit>().images,
                        context.read<MainImageCubit>().image,
                      );
                    }
                  },
          ),
          backgroundColor: context.theme.white100_1,
          appBar: AppBar(
            elevation: 1,
            shadowColor: AppLightColors.myBlack50,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        action: "Delete",
                        title: "Delete vehicle",
                        subtitle:
                            "Are you sure you want to delete this vehicle ?",
                        onPressed: () {
                          context.read<EditVehicleCubit>().deleteVehicle(
                                widget.vehicleId,
                              );
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppLightColors.myBlack100,
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
                color: AppLightColors.myBlack100,
              ),
            ),
            backgroundColor: AppLightColors.myWhite100_1,
            title: Text(
              'Edit Vehicle',
              style: AppStyles.semiBold24(context),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: Form(
                      key: context.read<EditVehicleCubit>().editVehicleFormKey,
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
                            // Pass these values from your vehicleData
                            initialVehicleBrand: vehicleData?.vehicleBrand.name,
                            initialVehicleType: vehicleData?.vehicleType.name,
                          ),
                          const Gap(25),
                          VehicleImagesSection(
                            initialMainImageUrl: state is EditVehicleDataLoaded
                                ? state.vehicleData.mainImagePath
                                : null,
                            initialMainImagesUrl: state is EditVehicleDataLoaded
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
                                    state.vehicleData.location.latitude,
                                    state.vehicleData.location.longitude,
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
