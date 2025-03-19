import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_pick_location_on_map_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class VehicleLocationSection extends StatefulWidget {
  const VehicleLocationSection({
    super.key,
    required this.vehicleAddressController,
    this.initialLocation,
    this.onLocationSelected,
  });

  final TextEditingController vehicleAddressController;
  final LatLng? initialLocation;
  final Function(LatLng, String)? onLocationSelected;

  @override
  State<VehicleLocationSection> createState() => _VehicleLocationSectionState();
}

class _VehicleLocationSectionState extends State<VehicleLocationSection> {
  String selectedAddress = "";
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
    // Initialize address from controller if it's not empty
    if (widget.vehicleAddressController.text.isNotEmpty) {
      selectedAddress = widget.vehicleAddressController.text;
    }
  }

  void _handleLocationSelected(LatLng location, String address) {
    setState(() {
      selectedLocation = location;
      selectedAddress = address;
      // Update the text controller with the new address
      widget.vehicleAddressController.text = address;
    });

    // Pass the location and address to parent
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(location, address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Location:",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        const Gap(10),
        InputNameWithInputFieldSection(
          controller: widget.vehicleAddressController,
          validator: (value) {
            if (value!.isEmpty) {
              return "required";
            }
            return null;
          },
          width: double.infinity,
          label: "Vehicle address",
          hintText: "Minya al-Qamh, Sharkia, Egypt",
        ),
        const Gap(10),
        VehiclePickLocationOnMapSection(
          initialLocation: selectedLocation,
          onLocationSelected: _handleLocationSelected,
        ),
      ],
    );
  }
}
