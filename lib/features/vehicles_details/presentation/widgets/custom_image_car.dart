import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomImageCar extends StatelessWidget {
  const CustomImageCar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.myBlack25,
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 4,
            ),
          ],
        ),
        child: const ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
          child: Image(
            image: AssetImage(
              AppAssets.assetsImagesCar,
            ),
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
