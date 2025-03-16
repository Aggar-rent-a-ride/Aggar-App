import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_location_on_map_button.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class VehiclePickLocationOnMapSection extends StatefulWidget {
  const VehiclePickLocationOnMapSection({
    super.key,
  });

  @override
  State<VehiclePickLocationOnMapSection> createState() =>
      _VehiclePickLocationOnMapSectionState();
}

class _VehiclePickLocationOnMapSectionState
    extends State<VehiclePickLocationOnMapSection> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle location",
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        FormField(
          validator: (value) {
            if (selectedLocation == null) {
              return 'Please select a location on the map';
            }
            return null;
          },
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PickLocationOnMapButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapScreen(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      selectedLocation = result;
                    });
                    field.didChange(result);
                  }
                },
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    field.errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
