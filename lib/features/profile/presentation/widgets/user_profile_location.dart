import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserProfileLocation extends StatelessWidget {
  const UserProfileLocation({
    super.key,
    required this.userLocation,
  });

  final LatLng userLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black26,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: FlutterMap(
            mapController: MapController(),
            options: MapOptions(
              initialCenter: userLocation,
              initialZoom: 14.0,
              maxZoom: 18.0,
              minZoom: 2.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourapp.name',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_on,
                      color: context.theme.red100_1,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
