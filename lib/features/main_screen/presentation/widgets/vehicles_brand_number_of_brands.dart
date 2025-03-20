import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class VehiclesBrandNumberOfBrands extends StatelessWidget {
  const VehiclesBrandNumberOfBrands({
    super.key,
    required this.numOfBrands,
  });

  final int numOfBrands;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: AppLightColors.myBlue10_2,
      ),
      child: Text(
        numOfBrands.toString(),
        style: AppStyles.regular10(context).copyWith(
          color: AppLightColors.myBlue100_2,
        ),
      ),
    );
  }
}
