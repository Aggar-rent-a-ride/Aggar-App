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
  });
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RentPartnerSection(),
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
