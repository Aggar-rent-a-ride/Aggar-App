import 'package:aggar/features/profile/presentation/widgets/address_text_container.dart';
import 'package:aggar/features/profile/presentation/widgets/location_icon_with_text.dart';
import 'package:aggar/features/profile/presentation/widgets/see_in_google_map_button.dart';
import 'package:aggar/features/profile/presentation/widgets/user_profile_location.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class MapSectionWidget extends StatelessWidget {
  const MapSectionWidget({
    super.key,
    required this.userLocation,
    required this.address,
  });

  final LatLng userLocation;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LocationIconWithText(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                UserProfileLocation(userLocation: userLocation),
                AddressTextContainer(address: address),
              ],
            ),
          ),
        ),
        SeeInGoogleMapButton(userLocation: userLocation, address: address),
        const Gap(25),
      ],
    );
  }
}
