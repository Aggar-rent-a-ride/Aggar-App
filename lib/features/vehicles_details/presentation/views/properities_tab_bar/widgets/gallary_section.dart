import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card_network.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class GallarySection extends StatelessWidget {
  GallarySection({
    super.key,
    required this.images,
    required this.mainImage,
    this.style,
  });

  final ScrollController _scrollController = ScrollController();
  final List<String?> images;
  final String mainImage;
  final TextStyle? style;

  void _openGallery(BuildContext context, int initialIndex) {
    List<String> allImages = [
      // Use mainImage if valid, otherwise fallback to AppAssets.assetsImagesCar
      mainImage.isNotEmpty ? mainImage : AppAssets.assetsImagesCar,
      ...images.where((img) => img != null).map((img) => img!),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(
          allImages: allImages,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are any valid additional images
    final hasAdditionalImages =
        images.any((img) => img != null && img.isNotEmpty);

    // If no additional images and mainImage is empty/invalid, show only the placeholder
    if (!hasAdditionalImages && mainImage.isEmpty) {
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
            GestureDetector(
              onTap: () => _openGallery(context, 0),
              child: Hero(
                tag: "image_0",
                child: Image.asset(
                  AppAssets.assetsImagesCar,
                  fit: BoxFit.cover,
                  height: MediaQuery.sizeOf(context).height * 0.03 + 50,
                  width: MediaQuery.sizeOf(context).height * 0.03 + 50,
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                padding: const EdgeInsets.only(
                    bottom: 15, top: 2, left: 2, right: 2),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openGallery(context, 0),
                      child: Hero(
                        tag: "image_0",
                        child: AdditionalImageCardNetwork(image: mainImage),
                      ),
                    ),
                    if (hasAdditionalImages)
                      ...List.generate(images.length, (index) {
                        if (images[index] != null &&
                            images[index]!.isNotEmpty) {
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
