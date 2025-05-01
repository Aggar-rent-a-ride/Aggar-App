import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapLocationOnlyMapScreen extends StatelessWidget {
  const MapLocationOnlyMapScreen({
    super.key,
    required this.location,
  });

  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: location,
        initialZoom: 16.0,
        maxZoom: 19.0,
        minZoom: 13.0,
      ),
      children: [
        TileLayer(
          //urlTemplate: 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: location,
              child: Icon(
                Icons.location_on,
                color: context.theme.red100_1,
                size: 35,
              ),
            )
          ],
        ),
      ],
    );
  }
}
