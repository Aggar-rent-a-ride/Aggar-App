import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  final String imagefrom;

  const ImageView({
    super.key,
    required this.imageUrl,
    required this.imagefrom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.myBlack100_1,
      appBar: AppBar(
        backgroundColor: AppConstants.myBlack100_1,
        leading: IconButton(
          padding: const EdgeInsets.all(0),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.theme.white100_1,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          imagefrom,
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.white100_1,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: AppConstants.myWhite100_1, size: 50),
                Text(
                  'Failed to load image',
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.white100_1,
                  ),
                ),
              ],
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              color: AppConstants.myWhite100_1,
            );
          },
        ),
      ),
    );
  }
}
