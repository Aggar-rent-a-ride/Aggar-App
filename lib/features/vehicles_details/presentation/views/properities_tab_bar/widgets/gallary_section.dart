import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card_network.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class GallarySection extends StatelessWidget {
  GallarySection(
      {super.key, required this.images, required this.mainImage, this.style});
  final ScrollController _scrollController = ScrollController();
  final List<String?> images;
  final String mainImage;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gallary",
            style: style ??
                AppStyles.bold18(context).copyWith(
                  color: AppLightColors.myGray100_3,
                ),
          ),
          const Gap(10),
          RawScrollbar(
            thumbVisibility: true,
            // padding: const EdgeInsets.symmetric(
            //  horizontal: 135), //TODO : must be dynamic
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
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    AdditionalImageCardNetwork(image: mainImage),
                    ...List.generate(images.length, (index) {
                      if (images[index] != null) {
                        return AdditionalImageCardNetwork(
                            image: images[index]!);
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
