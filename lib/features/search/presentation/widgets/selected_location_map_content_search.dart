import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SelectedLocationMapContentSearch extends StatelessWidget {
  final LatLng location;
  final String address;
  final Function(LatLng, String) onEditLocation;
  final String uniqueId;

  // Static counter to ensure unique hero tags
  static int _editLocationCounter = 0;

  const SelectedLocationMapContentSearch({
    super.key,
    required this.location,
    required this.address,
    required this.onEditLocation,
    required this.uniqueId,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a unique tag using the counter
    final String buttonTag = 'edit_location_${_editLocationCounter++}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Row(
        children: [
          Text(address),
          FloatingActionButton.small(
            heroTag: buttonTag,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    initialLocation: location,
                    screenId: buttonTag,
                  ),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                final latitude = result['latitude'] as double;
                final longitude = result['longitude'] as double;
                final newAddress = result['address'] as String? ?? '';
                onEditLocation(LatLng(latitude, longitude), newAddress);
              }
            },
            backgroundColor: context.theme.blue100_1,
            child: Icon(
              Icons.edit_location_alt_rounded,
              color: context.theme.blue10_2,
            ),
          ),
        ],
      ),
    );
  }
}
