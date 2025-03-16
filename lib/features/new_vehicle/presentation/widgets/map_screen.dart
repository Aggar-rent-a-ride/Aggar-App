import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/cubits/map_location/map_location_cubit.dart';
import '../../data/cubits/map_location/map_location_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapLocationCubit(),
      child: BlocConsumer<MapLocationCubit, MapLocationState>(
        listener: (context, state) {
          // Show errors if any
          if (state is MapLocationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          final mapLocationCubit = context.read<MapLocationCubit>();

          // Loading state
          if (state is MapLocationInitial || state is MapLocationLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Build the map when we have location
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => _showCoordinatesDialog(context),
                icon: const Icon(Icons.check),
              ),
            ),
            body: FlutterMap(
              mapController: mapLocationCubit.mapController,
              options: MapOptions(
                initialCenter: state is MapLocationSuccess
                    ? LatLng(
                        state.locationData.latitude!,
                        state.locationData.longitude!,
                      )
                    : state is CurrentLocationChanged
                        ? LatLng(
                            state.locationData.latitude!,
                            state.locationData.longitude!,
                          )
                        : const LatLng(0, 0),
                initialZoom: 16.0,
                onTap: (tapPosition, point) =>
                    mapLocationCubit.setSingleMarker(point),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: [
                    if (state is MarkerUpdated && state.markerPosition != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: state.markerPosition!,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40.0),
                      ),
                  ],
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => mapLocationCubit.showCurrentLocation(),
              child: const Icon(Icons.my_location),
            ),
          );
        },
      ),
    );
  }

  void _showCoordinatesDialog(BuildContext context) {
    final mapLocationCubit = context.read<MapLocationCubit>();

    if (mapLocationCubit.hasMarker()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Marker Coordinates'),
            content: Text(
              'Latitude: ${mapLocationCubit.getMarkerLatitude()}\n'
              'Longitude: ${mapLocationCubit.getMarkerLongitude()}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a marker first!')),
      );
    }
  }
}
