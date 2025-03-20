import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_type_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class VehiclesTypeSection extends StatelessWidget {
  const VehiclesTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicles Type",
          style: AppStyles.bold24(context).copyWith(
            color: AppLightColors.myBlue100_5,
          ),
        ),
        const Gap(8),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VehicleTypeCard(
                iconPrv: AppAssets.assetsIconsCarIcon,
                label: "Cars",
              ),
              VehicleTypeCard(
                iconPrv: AppAssets.assetsIconsTruckIcon,
                label: "Trucks",
              ),
              VehicleTypeCard(
                iconPrv: AppAssets.assetsIconsMotorcyclesIcon,
                label: "Motorcycles",
              ),
              VehicleTypeCard(
                iconPrv: AppAssets.assetsIconsRecreationalIcon,
                label: "Recreational",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
