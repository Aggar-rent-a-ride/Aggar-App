import 'package:aggar/core/widgets/map_location_only_map_screen.dart';
import 'package:aggar/core/widgets/map_location_show_only_address_section.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapLocationOnlyShow extends StatelessWidget {
  const MapLocationOnlyShow(
      {super.key, required this.location, required this.address});
  final LatLng location;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapLocationOnlyMapScreen(location: location),
          MapLocationShowOnlyAddressSection(address: address),
        ],
      ),
    );
  }
}
