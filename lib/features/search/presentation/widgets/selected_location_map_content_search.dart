import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:gap/gap.dart';

class SelectedLocationMapContentSearch extends StatelessWidget {
  final LatLng location;
  final String address;
  final Function(LatLng, String) onEditLocation;
  final String uniqueId;

  const SelectedLocationMapContentSearch({
    super.key,
    required this.location,
    required this.address,
    required this.onEditLocation,
    required this.uniqueId,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = address.isNotEmpty ? address : "Select a Location";

    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
              initialLocation: location,
              screenId: uniqueId,
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
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        overlayColor: WidgetStateProperty.all(context.theme.blue50_2),
        backgroundColor: WidgetStateProperty.all(context.theme.blue100_6),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            size: 16,
            color: context.theme.white100_2,
          ),
          const Gap(10),
          Expanded(
            child: Text(
              displayText,
              style: AppStyles.semiBold14(context).copyWith(
                color: context.theme.white100_2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
