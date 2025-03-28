import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/location_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/rent_partner_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutTabBarView extends StatelessWidget {
  const AboutTabBarView({
    super.key,
    required this.vehicleAddress,
    required this.vehicleLongitude,
    required this.vehicleLatitude,
    this.pfpImage,
    required this.renterName,
  });
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final String? pfpImage;
  final String renterName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RentPartnerSection(
          pfpImage: pfpImage,
          renterName: renterName,
        ),
        LocationSection(
          vehicleAddress: vehicleAddress,
          vehicleLongitude: vehicleLongitude,
          vehicleLatitude: vehicleLatitude,
        ),
        const Gap(25),
      ],
    );
  }
}
