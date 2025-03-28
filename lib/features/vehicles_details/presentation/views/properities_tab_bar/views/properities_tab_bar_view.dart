import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/gallary_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/over_view_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class ProperitiesTabBarView extends StatelessWidget {
  const ProperitiesTabBarView(
      {super.key,
      required this.vehicleColor,
      required this.vehicleOverView,
      required this.vehiceSeatsNo,
      required this.images,
      required this.mainImage,
      required this.vehicleHealth,
      required this.vehicleStatus});
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;
  final List<String?> images;
  final String mainImage;
  final String vehicleHealth;
  final String vehicleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GallarySection(
          images: images,
          mainImage: mainImage,
        ),
        OverViewSection(
          color: vehicleColor,
          carHealth: vehicleHealth,
          carHealthContainerColor: AppLightColors.myYellow10_1,
          carHealthTextColor: AppLightColors.myYellow100_1,
          carStatus: vehicleStatus,
          carStatusContainerColor: AppLightColors.myRed10_1,
          carStatusTextColor: AppLightColors.myRed100_1,
          overviewText: vehicleOverView,
          seatsno: vehiceSeatsNo,
        ),
        const Gap(25)
      ],
    );
  }
}
