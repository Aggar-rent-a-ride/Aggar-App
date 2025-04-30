import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    super.key,
    required this.allImages,
  });

  final List<String> allImages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        backgroundColor: context.theme.black100,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        iconTheme: IconThemeData(color: context.theme.white100_1),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage("${EndPoint.baseUrl}${allImages[index]}"),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: "image_$index"),
          );
        },
        itemCount: allImages.length,
        loadingBuilder: (context, event) => Center(
          // will change
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            color: context.theme.blue100_2,
          ),
        ),
        backgroundDecoration: BoxDecoration(color: context.theme.white100_1),
      ),
    );
  }
}
