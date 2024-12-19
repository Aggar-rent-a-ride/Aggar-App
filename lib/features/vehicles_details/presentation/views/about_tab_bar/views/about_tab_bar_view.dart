import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/location_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/rent_partner_section.dart';
import 'package:flutter/material.dart';

class AboutTabBarView extends StatelessWidget {
  const AboutTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [RentPartnerSection(), LocationSection()],
    );
  }
}
