import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/features/profile/presentation/widgets/address_card_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/current_location_with_icon.dart';
import 'package:aggar/features/profile/presentation/widgets/map_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class LocationContentWidget extends StatelessWidget {
  const LocationContentWidget({
    super.key,
    required this.state,
  });

  final UserInfoSuccess state;

  @override
  Widget build(BuildContext context) {
    final address = state.userInfoModel.address;
    final userLocation = LatLng(
      state.userInfoModel.location.latitude.toDouble(),
      state.userInfoModel.location.longitude.toDouble(),
    );

    final addressComponents = _parseAddress(address ?? "");

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurrentLocationWithIcon(),
            const Gap(10),
            AddressCardWidget(addressComponents: addressComponents),
            const Gap(24),
            MapSectionWidget(
              userLocation: userLocation,
              address: address ?? "",
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String?> _parseAddress(String address) {
    final components = address.split(',').map((e) => e.trim()).toList();
    return {
      'city': components.isNotEmpty ? components.last : null,
      'country':
          components.length > 1 ? components[components.length - 2] : null,
    };
  }
}
