import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/cubits/map_location/map_location_cubit.dart';
import '../../data/cubits/map_location/map_location_state.dart'
    show
        MapLocationFailure,
        MapLocationState,
        MapLocationSuccess,
        MapViewUpdated;

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MapLocationCubit();
        if (widget.initialLocation != null) {
          Future.microtask(() {
            cubit.setSingleMarker(widget.initialLocation!);
          });
        }

        return cubit;
      },
      child: BlocConsumer<MapLocationCubit, MapLocationState>(
        listener: (context, state) {
          if (state is MapLocationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          final mapCubit = context.read<MapLocationCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Pick Location',
                style: AppStyles.semiBold24(context),
              ),
              backgroundColor: AppColors.myWhite100_1,
              actions: [
                if (mapCubit.hasMarker())
                  TextButton(
                    onPressed: () {
                      _showConfirmationDialog(context, mapCubit);
                    },
                    child: Text(
                      'Confirm',
                      style: AppStyles.medium16(context).copyWith(
                        color: AppColors.myBlue100_1,
                      ),
                    ),
                  ),
              ],
            ),
            body: Stack(
              children: [
                _buildMap(context, mapCubit),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.myBlue100_1,
                    onPressed: () {
                      mapCubit.showCurrentLocation();
                    },
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context, MapLocationCubit mapCubit) {
    return BlocBuilder<MapLocationCubit, MapLocationState>(
      builder: (context, state) {
        LatLng center =
            widget.initialLocation ?? const LatLng(30.0444, 31.2357);
        double zoom = 16;

        if (state is MapLocationSuccess && mapCubit.currentLocation != null) {
          center = LatLng(
            mapCubit.currentLocation!.latitude!,
            mapCubit.currentLocation!.longitude!,
          );
        }

        if (state is MapViewUpdated) {
          center = state.center;
          zoom = state.zoom;
        }

        return FlutterMap(
          mapController: mapCubit.mapController,
          options: MapOptions(
            initialZoom: 16.0,
            maxZoom: zoom,
            initialCenter: center,
            interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.all),
            onTap: (_, point) {
              mapCubit.setSingleMarker(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.aggar',
            ),
            if (mapCubit.markerPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: mapCubit.markerPosition!,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(
      BuildContext context, MapLocationCubit mapCubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Location',
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Location:',
              style: AppStyles.regular16(context),
            ),
            const SizedBox(height: 10),
            Text(
              'Latitude: ${mapCubit.getMarkerLatitude()}',
              style: AppStyles.regular14(context),
            ),
            Text(
              'Longitude: ${mapCubit.getMarkerLongitude()}',
              style: AppStyles.regular14(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: AppStyles.regular14(context).copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, mapCubit.markerPosition);
            },
            child: Text(
              'OK',
              style: AppStyles.medium14(context).copyWith(
                color: AppColors.myBlue100_1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
