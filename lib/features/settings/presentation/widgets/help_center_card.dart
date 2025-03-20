import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class HelpCenterCard extends StatelessWidget {
  const HelpCenterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 10,
      onPressed: () {},
      backgroundColor: AppLightColors.myBlue100_7,
      child: Row(
        children: [
          const Image(
            image: AssetImage(
              AppAssets.assetsIconsHelpCenter,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Help Center",
            style: AppStyles.bold16(context).copyWith(
              color: AppLightColors.myBlue100_1,
            ),
          ),
          const Spacer(),
          const ArrowForwardIconButton(),
        ],
      ),
    );
  }
}
