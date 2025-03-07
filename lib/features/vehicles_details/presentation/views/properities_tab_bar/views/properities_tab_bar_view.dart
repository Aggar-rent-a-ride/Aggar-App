import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/gallary_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/over_view_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class ProperitiesTabBarView extends StatelessWidget {
  const ProperitiesTabBarView(
      {super.key,
      required this.vehicleColor,
      required this.vehicleOverView,
      required this.vehiceSeatsNo});
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GallarySection(),
        OverViewSection(
          color: vehicleColor,
          carHealth: "minor dents",
          carHealthContainerColor: AppColors.myYellow10_1,
          carHealthTextColor: AppColors.myYellow100_1,
          carStatus: "out of service",
          carStatusContainerColor: AppColors.myRed10_1,
          carStatusTextColor: AppColors.myRed100_1,
          overviewText: vehicleOverView,
          seatsno: vehiceSeatsNo,
        ),
        const Gap(25)
      ],
    );
  }
}
