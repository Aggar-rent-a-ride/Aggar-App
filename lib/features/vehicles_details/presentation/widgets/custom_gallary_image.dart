import 'package:aggar/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class CustomGallaryImage extends StatelessWidget {
  const CustomGallaryImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.28,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
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
