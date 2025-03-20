import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleTypeCard extends StatelessWidget {
  const VehicleTypeCard(
      {super.key, required this.iconPrv, required this.label});
  final String iconPrv;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      decoration: BoxDecoration(
        color: AppLightColors.myWhite100_2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            CustomIcon(
              hight: 35,
              width: 35,
              flag: false,
              imageIcon: iconPrv,
            ),
            const Gap(10),
            Text(
              label,
              style: AppStyles.medium12(context),
            ),
          ],
        ),
      ),
    );
  }
}
