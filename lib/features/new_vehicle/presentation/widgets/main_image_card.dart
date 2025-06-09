import 'dart:io';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/full_screen_photo_view.dart';
import 'package:flutter/material.dart';

class MainImageCard extends StatelessWidget {
  final File? image;
  final VoidCallback? onRemove;

  const MainImageCard({
    super.key,
    required this.image,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenPhotoView(
                image: image!,
                onRemove: onRemove,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: context.theme.black25,
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
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
