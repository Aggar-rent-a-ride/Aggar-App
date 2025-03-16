import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class VehiclePickLocationOnMapSection extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng)? onLocationSelected;

  const VehiclePickLocationOnMapSection({
    super.key,
    this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<VehiclePickLocationOnMapSection> createState() =>
      _VehiclePickLocationOnMapSectionState();
}

class _VehiclePickLocationOnMapSectionState
    extends State<VehiclePickLocationOnMapSection> {
  LatLng? selectedLocation;
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

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
        const SizedBox(height: 10),
        FormField(
          key: _formFieldKey,
          initialValue: selectedLocation,
          validator: (value) {
            if (selectedLocation == null) {
              return 'Please select a location on the map';
            }
            return null;
          },
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedLocation == null)
                _buildPickLocationButton(context, field)
              else
                _buildSelectedLocationMap(context, field),
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

  Widget _buildPickLocationButton(BuildContext context, FormFieldState field) {
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
      height: MediaQuery.sizeOf(context).height * 0.18,
      child: ElevatedButton(
        onPressed: () => _navigateToMapScreen(context, field),
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.all(AppColors.myBlue50_2),
          backgroundColor: WidgetStateProperty.all(
            AppColors.myBlue100_8,
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
            color: AppColors.myBlue100_1,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedLocationMap(BuildContext context, FormFieldState field) {
    // Create a unique key for the map to force rebuild when location changes
    final mapKey = ValueKey(selectedLocation.toString());

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
      height: MediaQuery.sizeOf(context).height * 0.18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            FlutterMap(
              key: mapKey,
              options: MapOptions(
                initialCenter: selectedLocation!,
                initialZoom: 11,
                maxZoom: 11,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.aggar',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
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
                backgroundColor: AppColors.myBlue100_1,
                onPressed: () => _navigateToMapScreen(context, field),
                child: const Icon(
                  Icons.edit_location_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToMapScreen(
      BuildContext context, FormFieldState field) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(initialLocation: selectedLocation),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedLocation = result;
      });
      field.didChange(result);
      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(selectedLocation!);
      }
      _formFieldKey.currentState?.validate();
    }
  }
}
