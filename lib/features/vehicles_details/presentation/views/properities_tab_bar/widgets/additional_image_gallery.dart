import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdditionalImageGallery extends StatelessWidget {
  const AdditionalImageGallery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Container(
        height: MediaQuery.sizeOf(context).width * 0.20,
        width: MediaQuery.sizeOf(context).width * 0.26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.myBlue100_7,
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
