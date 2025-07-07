import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    super.key,
    required this.allImages,
    this.initialIndex = 0,
  });

  final List<String> allImages;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: AppConstants.myBlack100_1,
      appBar: AppBar(
        backgroundColor: context.theme.black100,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: context.theme.white100_1),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          // Determine if the image is a network URL or asset
          final imagePath = allImages[index];
          final isNetworkImage = !imagePath.startsWith('assets/');

          return PhotoViewGalleryPageOptions(
            imageProvider: isNetworkImage
                ? NetworkImage("${EndPoint.baseUrl}$imagePath")
                : AssetImage(imagePath) as ImageProvider,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: "image_$index"),
            errorBuilder: (context, error, stackTrace) => Image.asset(
              AppAssets.assetsImagesCar,
              fit: BoxFit.contain,
            ),
          );
        },
        itemCount: allImages.length,
        pageController: pageController,
        loadingBuilder: (context, event) => Center(
          child: SpinKitThreeBounce(
            color: context.theme.blue100_2,
            size: 30.0,
          ),
        ),
        backgroundDecoration: BoxDecoration(color: context.theme.white100_1),
      ),
    );
  }
}
