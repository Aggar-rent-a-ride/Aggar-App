import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/gallary_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/over_view_section.dart';
import 'package:flutter/material.dart';

class ProperitiesTabBarView extends StatelessWidget {
  const ProperitiesTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GallarySection(),
        OverViewSection(
          color: "red",
          carHealth: "minor dents",
          carHealthContainerColor: AppColors.myYellow10_1,
          carHealthTextColor: AppColors.myYellow100_1,
          carStatus: "out of service",
          carStatusContainerColor: AppColors.myRed10_1,
          carStatusTextColor: AppColors.myRed100_1,
          overviewText:
              "Discover the with its unique design with innovative SUV code . its characteristic and original design combines power Discover the with its unique design with innovative SUV code . its characteristic and original design combines power Discover the with its unique design with innovative SUV code . its characteristic and original design combines power ",
          seatsno: "9",
        )
      ],
    );
  }
}
