import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_style.dart';
import 'package:flutter/material.dart';

class PickMainImageButtonContent extends StatelessWidget {
  const PickMainImageButtonContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PickMainImageButtonStyle(
      onPressed: () {},
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage(
              AppAssets.assetsIconsPickimage,
            ),
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          Text(
            textAlign: TextAlign.center,
            "click here to pick \nmain image ",
            style: AppStyles.regular16(context).copyWith(
              color: AppColors.myBlue100_1,
            ),
          )
        ],
      ),
    );
  }
}
