import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card_network.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/photo_screen.dart';
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

  void _openGallery(BuildContext context, int initialIndex) {
    List<String> allImages = [
      mainImage,
      ...images.where((img) => img != null).map((img) => img!)
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(allImages: allImages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gallery",
            style: style ??
                AppStyles.bold18(context).copyWith(
                  color: context.theme.gray100_3,
                ),
          ),
          const Gap(10),
          RawScrollbar(
            padding: const EdgeInsets.symmetric(horizontal: 140),
            thumbVisibility: true,
            minThumbLength: 40,
            trackVisibility: true,
            trackRadius: const Radius.circular(50),
            trackColor: context.theme.gray100_1,
            controller: _scrollController,
            thumbColor: context.theme.blue100_2,
            radius: const Radius.circular(20),
            thickness: 8,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openGallery(context, 0),
                      child: Hero(
                        tag: "image_0",
                        child: AdditionalImageCardNetwork(image: mainImage),
                      ),
                    ),
                    ...List.generate(images.length, (index) {
                      if (images[index] != null) {
                        return GestureDetector(
                          onTap: () => _openGallery(context, index + 1),
                          child: Hero(
                            tag: "image_${index + 1}",
                            child: AdditionalImageCardNetwork(
                                image: images[index]!),
                          ),
                        );
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
