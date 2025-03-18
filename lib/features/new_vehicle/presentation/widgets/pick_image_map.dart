import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class PickImageMap extends StatelessWidget {
  const PickImageMap({super.key, required this.markers});
  final List<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapLocationCubit, MapLocationState>(
      builder: (context, state) {
        return FlutterMap(
          mapController: context.read<MapLocationCubit>().mapController,
          options: MapOptions(
            initialCenter: context.read<MapLocationCubit>().selectedLocation ??
                MapLocationCubit.defaultLocation,
            initialZoom: 13.0,
            onTap: (tapPosition, point) {
              context.read<MapLocationCubit>().updateSelectedLocation(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
