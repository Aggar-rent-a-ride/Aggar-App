import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class OwnerImageSection extends StatelessWidget {
  const OwnerImageSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: AppLightColors.myBlack25,
            spreadRadius: 0,
            blurRadius: 4,
          )
        ],
      ),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        child: Image(
          image: AssetImage(
            AppAssets.assetsImagesAvatar,
          ),
          height: 45,
        ),
      ),
    );
  }
}
