import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class AdditionalImageGallery extends StatelessWidget {
  const AdditionalImageGallery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 35),
      child: Container(
        height: MediaQuery.sizeOf(context).width * 0.25,
        width: MediaQuery.sizeOf(context).width * 0.30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppLightColors.myBlue100_7,
          image: const DecorationImage(
            image: AssetImage(
              AppAssets.assetsImagesCar,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
