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
      required this.vehicleStatus,
      required this.vehicleType});
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;
  final List<String?> images;
  final String mainImage;
  final String vehicleHealth;
  final String vehicleStatus;
  final String vehicleType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallarySection(
            images: images,
            mainImage: mainImage,
          ),
          OverViewSection(
            vehicleType: vehicleType,
            color: vehicleColor,
            carHealth: vehicleHealth,
            carStatus: vehicleStatus,
            overviewText: vehicleOverView,
            seatsno: vehiceSeatsNo,
          ),
          const Gap(25)
        ],
      ),
    );
  }
}
