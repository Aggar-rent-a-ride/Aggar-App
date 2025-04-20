import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/text_with_arrow_back_button.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/current_location_with_distance_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/image_of_current_vehicle_location.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class LocationSection extends StatelessWidget {
  const LocationSection({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        Text(
          "Location",
          style: AppStyles.bold18(context).copyWith(
            color: context.theme.gray100_3,
          ),
        ),
        CurrentLocationWithDistanceSection(
          vehicleAddress: vehicleAddress,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: ImageOfCurrentVehicleLocation(
              latitude: vehicleLatitude,
              longitude: vehicleLongitude,
            ),
          ),
        ),
        const Gap(5),
        const TextWithArrowBackButton(
          text: "see in google map",
        ),
      ],
    );
  }
}
