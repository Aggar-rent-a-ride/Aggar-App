import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomImageCar extends StatelessWidget {
  const CustomImageCar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.3,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10,
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
          Radius.circular(10),
        ),
        child: Image(
          image: AssetImage(
            AppAssets.assetsImagesCar,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
