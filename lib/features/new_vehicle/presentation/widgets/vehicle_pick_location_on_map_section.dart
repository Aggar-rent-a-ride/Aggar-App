import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_location_on_map_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/selected_location_map_contnet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class VehiclePickLocationOnMapSection extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String)? onLocationSelected;
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
  String address = '';
  final String uniqueId = const Uuid().v4();

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
          style: AppStyles.bold22(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
        const Gap(10),
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
                PickLocationOnMapButton(
                  onPickLocation: (LatLng location, String locationAddress) {
                    setState(() {
                      selectedLocation = location;
                      address = locationAddress;
                    });
                    field.didChange(location);
                    _formFieldKey.currentState?.validate();
                    widget.onLocationSelected?.call(location, locationAddress);
                  },
                )
              else
                SelectedLocationMapContent(
                  location: selectedLocation!,
                  address: address,
                  onEditLocation: (LatLng location, String locationAddress) {
                    setState(() {
                      selectedLocation = location;
                      address = locationAddress;
                    });
                    field.didChange(location);
                    _formFieldKey.currentState?.validate();
                    widget.onLocationSelected?.call(location, locationAddress);
                  },
                  uniqueId: uniqueId,
                ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    field.errorText!,
                    style: AppStyles.regular14(context).copyWith(
                      color: context.theme.red100_1,
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
