import 'dart:io';

import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class GallarySection extends StatelessWidget {
  GallarySection({super.key, required this.images, required this.mainImage});
  final ScrollController _scrollController = ScrollController();
  final List<File?> images;
  final File mainImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gallary",
            style: AppStyles.bold18(context).copyWith(
              color: AppLightColors.myGray100_3,
            ),
          ),
          RawScrollbar(
            thumbVisibility: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 135), // must be dynamic
            minThumbLength: 40, // must be dynamic
            trackVisibility: true,
            trackRadius: const Radius.circular(50),
            trackColor: AppLightColors.myGray100_1,
            controller: _scrollController,
            thumbColor: AppLightColors.myBlue100_2,
            radius: const Radius.circular(20),
            thickness: 8,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    AdditionalImageCard(image: mainImage),
                    ...List.generate(images.length, (index) {
                      if (images[index] != null) {
                        return AdditionalImageCard(image: images[index]!);
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
