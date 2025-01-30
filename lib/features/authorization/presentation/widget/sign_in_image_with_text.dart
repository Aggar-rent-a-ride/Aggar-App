import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SignInImageWithText extends StatelessWidget {
  const SignInImageWithText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: const AssetImage(AppAssets.assetsImagesSignUpImg),
          width: MediaQuery.sizeOf(context).width * 0.5,
          height: 200,
          fit: BoxFit.fitWidth,
        ),
        Text(
          "Let's log you in",
          style: AppStyles.bold28(context),
        ),
      ],
    );
  }
}
