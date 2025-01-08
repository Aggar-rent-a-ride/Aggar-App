import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NoMessagesView extends StatelessWidget {
  const NoMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage(
            AppAssets.assetsImagesNochat,
          ),
          height: 225,
          width: 225,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "no chats yet!",
              style: TextStyle(
                color: AppColors.myBlue100_1,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              " start chating",
              style: TextStyle(
                color: AppColors.myBlue100_2,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }
}
