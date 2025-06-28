import 'package:aggar/core/widgets/map_location_only_show.dart';
import 'package:aggar/core/widgets/text_with_arrow_back_button.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SeeInGoogleMapButton extends StatelessWidget {
  const SeeInGoogleMapButton({
    super.key,
    required this.userLocation,
    required this.address,
  });

  final LatLng userLocation;
  final String address;

  @override
  Widget build(BuildContext context) {
    return TextWithArrowBackButton(
      text: "see in google map",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MapLocationOnlyShow(
                location: LatLng(
                  userLocation.latitude,
                  userLocation.longitude,
                ),
                address: address,
              );
            },
          ),
        );
      },
    );
  }
}
