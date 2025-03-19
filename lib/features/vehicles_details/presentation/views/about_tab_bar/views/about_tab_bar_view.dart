import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/location_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/rent_partner_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class AboutTabBarView extends StatelessWidget {
  const AboutTabBarView({
    super.key,
    required this.vehicleAddress,
    required this.vehicleLongitude,
    required this.vehicleLatitude,
    this.initialLocation,
    this.onLocationSelected,
  });
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final LatLng? initialLocation;
  final Function(LatLng, String)? onLocationSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RentPartnerSection(),
        LocationSection(
          vehicleAddress: vehicleAddress,
          vehicleLongitude: vehicleLongitude,
          vehicleLatitude: vehicleLatitude,
          initialLocation: initialLocation,
          onLocationSelected: onLocationSelected,
        ),
        const Gap(25),
      ],
    );
  }
}
