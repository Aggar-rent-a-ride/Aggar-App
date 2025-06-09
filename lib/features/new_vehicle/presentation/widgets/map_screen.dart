import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/address_search_bar.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_image_map.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/selected_location_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/confirm_location_with_pick_current_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_state.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/location_state_type.dart';

class MapScreen extends StatelessWidget {
  final LatLng? initialLocation;
  final String? screenId;

  const MapScreen({
    super.key,
    this.initialLocation,
    this.screenId,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueId = screenId ?? const Uuid().v4();

    return BlocProvider(
      create: (context) => MapLocationCubit(initialLocation: initialLocation),
      child: _MapScreenContent(uniqueId: uniqueId),
    );
  }
}

class _MapScreenContent extends StatelessWidget {
  final String uniqueId;

  const _MapScreenContent({
    required this.uniqueId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapLocationCubit, MapLocationState>(
        listener: (context, state) {
          if (state is MapLocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                context,
                "Error",
                "Map Location failed!",
                SnackBarType.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final currentMarkers = getMarkersFromState(state);
          final currentAddress = getAddressFromState(state);
          final isLoading = isAddressLoadingFromState(state);

          return Stack(
            children: [
              Positioned.fill(
                child: PickImageMap(markers: currentMarkers),
              ),
              const Positioned(
                top: 35,
                left: 16,
                right: 16,
                child: AddressSearchBar(),
              ),
              ConfirmLocationWithPickCurrentLocation(
                  uniqueId: 'map_screen_$uniqueId'),
              if (currentAddress.isNotEmpty)
                SelectedLocationSection(
                  isLoading: isLoading,
                  address: currentAddress,
                ),
              if (state is MapLocationLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}
