import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/utils/app_constants.dart';

class MainScreenLocationIconAndLocationText extends StatelessWidget {
  const MainScreenLocationIconAndLocationText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomIcon(
          hight: 20,
          width: 20,
          flag: false,
          imageIcon: AppAssets.assetsIconsLocation,
        ),
        const Gap(5),
        Text(
          "Minya al-Qamh, Sharkia, Egypt",
          style: AppStyles.medium18(context).copyWith(
            color: AppConstants.myWhite100_1.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
