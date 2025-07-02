import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class PickLocationOnMapIconButton extends StatelessWidget {
  const PickLocationOnMapIconButton({
    super.key,
    required this.onPickLocation,
    this.color,
  });
  final Function(LatLng, String) onPickLocation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final String uniqueId = const Uuid().v4();

    return ElevatedButton(
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
        overlayColor: WidgetStateProperty.all(context.theme.blue50_2),
        backgroundColor: WidgetStateProperty.all(
          color ?? context.theme.blue100_6,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 16,
            color: context.theme.white100_2,
          ),
          const Gap(10),
          Text(
            "Pick a Location on Map ( your location is the default )",
            style: AppStyles.semiBold14(context).copyWith(
              color: context.theme.white100_2,
            ),
          ),
        ],
      ),
    );
  }
}
