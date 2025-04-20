import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_screen.dart';

class SelectedLocationMapContent extends StatelessWidget {
  final LatLng location;
  final String address;
  final Function(LatLng, String) onEditLocation;

  const SelectedLocationMapContent({
    super.key,
    required this.location,
    required this.address,
    required this.onEditLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: context.theme.black25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ],
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: location,
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
                      point: location,
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
            Positioned(
              bottom: 8,
              right: 8,
              child: FloatingActionButton.small(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MapScreen(initialLocation: location),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    final latitude = result['latitude'] as double;
                    final longitude = result['longitude'] as double;
                    final newAddress = result['address'] as String? ?? '';
                    onEditLocation(LatLng(latitude, longitude), newAddress);
                  }
                },
                backgroundColor: context.theme.blue100_2,
                child: Icon(
                  Icons.edit_location_alt_rounded,
                  color: context.theme.blue10_2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
