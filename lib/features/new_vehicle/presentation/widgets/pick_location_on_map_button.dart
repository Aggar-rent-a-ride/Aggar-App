import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class PickLocationOnMapButton extends StatelessWidget {
  const PickLocationOnMapButton({
    super.key,
    required this.onPickLocation,
    this.color,
    this.textColor,
  });
  final Function(LatLng, String) onPickLocation;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final String uniqueId = const Uuid().v4();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.18,
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(screenId: uniqueId),
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
          overlayColor: WidgetStateProperty.all(
            context.theme.blue100_1.withOpacity(0.5),
          ),
          backgroundColor: WidgetStateProperty.all(
            color ?? context.theme.blue100_1.withOpacity(0.15),
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
          style: AppStyles.medium16(context).copyWith(
            color: textColor ?? context.theme.blue100_1,
          ),
        ),
      ),
    );
  }
}
