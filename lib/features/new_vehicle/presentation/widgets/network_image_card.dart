import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class NetworkImageCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const NetworkImageCard({
    super.key,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final String fullImageUrl = "https://aggarapi.runasp.net$imageUrl";

    return GestureDetector(
      onTap: () => _openPhotoView(context, fullImageUrl),
      onLongPress: () => _showDeleteDialog(context),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(fullImageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Remove Image",
        actionTitle: "Remove",
        subtitle: 'Are you sure you want to remove this image?',
        onPressed: () {
          Navigator.pop(context);
          onRemove();
        },
      ),
    );
  }

  void _openPhotoView(BuildContext context, String fullImageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenNetworkPhotoView(
          imageUrl: fullImageUrl,
          onRemove: onRemove,
        ),
      ),
    );
  }
}

class _FullScreenNetworkPhotoView extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const _FullScreenNetworkPhotoView({
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CustomDialog(
                title: "Remove Image",
                actionTitle: "Remove",
                subtitle: 'Are you sure you want to remove this image?',
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close photo view
                  onRemove();
                },
              ),
            ),
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          ),
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 40),
              SizedBox(height: 16),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
