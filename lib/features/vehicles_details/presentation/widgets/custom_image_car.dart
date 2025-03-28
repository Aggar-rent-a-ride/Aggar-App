import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class CustomImageCar extends StatelessWidget {
  const CustomImageCar({
    super.key,
    required this.mainImage,
  });
  final String mainImage;
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
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          "${EndPoint.baseUrl}$mainImage",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
