import 'package:aggar/core/themes/app_light_colors.dart';
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
            color: AppLightColors.myBlack25,
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
                        color: AppLightColors.myRed100_1,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            /* if (address.isNotEmpty)
              Positioned(
                bottom: 40,
                left: 8,
                right: 48,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.myBlack100,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),*/
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
                backgroundColor: AppLightColors.myBlue100_2,
                child: Icon(
                  Icons.edit_location_alt_rounded,
                  color: AppLightColors.myBlue10_2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
