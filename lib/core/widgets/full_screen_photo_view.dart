import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';

class FullScreenPhotoView extends StatelessWidget {
  final File image;
  final VoidCallback? onRemove;
  final String? heroTag;

  const FullScreenPhotoView({
    super.key,
    required this.image,
    this.onRemove,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final String uniqueHeroTag =
        heroTag ?? '${image.path}_${const Uuid().v4()}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      body: PhotoView(
        imageProvider: FileImage(image),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        heroAttributes: PhotoViewHeroAttributes(tag: uniqueHeroTag),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image'),
        content: const Text('Are you sure you want to remove this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              onRemove?.call();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
