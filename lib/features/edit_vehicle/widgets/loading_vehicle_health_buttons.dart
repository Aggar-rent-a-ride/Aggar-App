import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class LoadingVehicleHealthButtons extends StatelessWidget {
  const LoadingVehicleHealthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppLightColors.myWhite100_1,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
