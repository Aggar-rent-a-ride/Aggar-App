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
    required this.renterId,
  });

  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final String? pfpImage;
  final String renterName;
  final int renterId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          RentPartnerSection(
            pfpImage: pfpImage,
            renterName: renterName,
            renterId: renterId,
          ),
          LocationSection(
            vehicleAddress: vehicleAddress,
            vehicleLongitude: vehicleLongitude,
            vehicleLatitude: vehicleLatitude,
          ),
          const Gap(25),
        ],
      ),
    );
  }
}
