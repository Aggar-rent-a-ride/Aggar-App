import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PickLocationOnMapButton extends StatelessWidget {
  const PickLocationOnMapButton({
    super.key,
    required this.onPickLocation,
  });
  final Function(LatLng, String) onPickLocation;

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
      height: MediaQuery.sizeOf(context).height * 0.18,
      child: ElevatedButton(
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
            final address = result['address'] as String? ?? '';
            onPickLocation(LatLng(latitude, longitude), address);
          }
        },
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.all(context.theme.blue50_2),
          backgroundColor: WidgetStateProperty.all(
            context.theme.blue10_2,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 25,
            ),
          ),
        ),
        child: Text(
          "Pick on Map",
          style: AppStyles.regular16(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
      ),
    );
  }
}
