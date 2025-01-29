import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';

class PickImageIconWithTitleAndSubtitle extends StatelessWidget {
  const PickImageIconWithTitleAndSubtitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        spacing: 5,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.myBlue100_2,
            radius: 90,
            child: const CustomIcon(
              hight: 80,
              width: 80,
              flag: false,
              imageIcon: AppAssets.assetsIconsAddPhoto,
            ),
          ),
          Text(
            "Profile photo",
            style: AppStyles.semiBold24(context).copyWith(
              color: AppColors.myBlue100_1,
            ),
          ),
          Text(
            "Please make sure that the photo you \n    upload will not be modified later",
            style: AppStyles.regular12(context).copyWith(
              color: AppColors.myBlack50,
            ),
          ),
        ],
      ),
    );
  }
}
