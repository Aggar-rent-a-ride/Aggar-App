import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/map_location_only_show.dart';
import 'package:aggar/core/widgets/text_with_arrow_back_button.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/current_location_with_distance_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/image_of_current_vehicle_location.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class LocationSection extends StatelessWidget {
  const LocationSection({
    super.key,
    required this.vehicleAddress,
    required this.vehicleLongitude,
    required this.vehicleLatitude,
    this.style,
  });
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        Text(
          "Location",
          style: style ??
              AppStyles.bold18(context).copyWith(
                color: context.theme.black100,
              ),
        ),
        CurrentLocationWithDistanceSection(
          vehicleAddress: vehicleAddress,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                color: Colors.black12,
                spreadRadius: 0,
                blurRadius: 4,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
              width: double.infinity,
              child: ImageOfCurrentVehicleLocation(
                latitude: vehicleLatitude,
                longitude: vehicleLongitude,
              ),
            ),
          ),
        ),
        const Gap(5),
        TextWithArrowBackButton(
          text: "see in google map",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MapLocationOnlyShow(
                    location: LatLng(vehicleLatitude, vehicleLongitude),
                    address: vehicleAddress,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
