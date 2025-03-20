import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_list_view.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_content.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class VehicleImagesSection extends StatefulWidget {
  const VehicleImagesSection({super.key});

  @override
  _VehicleImagesSectionState createState() => _VehicleImagesSectionState();
}

class _VehicleImagesSectionState extends State<VehicleImagesSection> {
  File? mainImage;

  void onMainImagePicked(File image) {
    setState(() {
      mainImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Images :",
          style: AppStyles.bold22(context).copyWith(
            color: AppLightColors.myBlue100_2,
          ),
        ),
        PickMainImageButtonContent(
          onImagePicked: onMainImagePicked,
        ),
        Text(
          "additional images",
          style: AppStyles.medium18(context).copyWith(
            color: AppLightColors.myBlue100_1,
          ),
        ),
        AdditionalImageListView(
          mainImage: mainImage,
        ),
      ],
    );
  }
}
