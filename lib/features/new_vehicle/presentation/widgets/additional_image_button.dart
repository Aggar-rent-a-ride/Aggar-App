import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdditionalImageButton extends StatelessWidget {
  const AdditionalImageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 3,
        right: 10,
      ),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
          BoxShadow(
            color: AppColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ]),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            elevation: WidgetStateProperty.all(0),
            overlayColor: WidgetStateProperty.all(AppColors.myBlue50_2),
            backgroundColor: WidgetStateProperty.all(
              AppColors.myBlue100_8,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 25,
              ),
            ),
          ),
          child: Image(
            image: const AssetImage(
              AppAssets.assetsIconsAdditionalImage,
            ),
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
        ),
      ),
    );
  }
}
