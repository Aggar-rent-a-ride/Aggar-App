import 'dart:io';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class AdditionalImageCard extends StatelessWidget {
  const AdditionalImageCard({
    super.key,
    required this.image,
  });
  final File? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          image!,
          fit: BoxFit.cover,
          height: MediaQuery.sizeOf(context).height * 0.03 + 50,
          width: MediaQuery.sizeOf(context).height * 0.03 + 50,
        ),
      ),
    );
  }
}
