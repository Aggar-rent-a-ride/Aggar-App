import 'package:aggar/core/utils/app_colors.dart';
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
            color: AppColors.myBlack25,
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
              options: MapOptions(
                initialCenter: location,
                maxZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.myRed100_1,
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
                      builder: (context) => const MapScreen(),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    final latitude = result['latitude'] as double;
                    final longitude = result['longitude'] as double;
                    final newAddress = result['address'] as String? ?? '';
                    onEditLocation(LatLng(latitude, longitude), newAddress);
                  }
                },
                backgroundColor: AppColors.myBlue100_2,
                child: Icon(
                  Icons.edit_location_alt_rounded,
                  color: AppColors.myBlue100_8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
