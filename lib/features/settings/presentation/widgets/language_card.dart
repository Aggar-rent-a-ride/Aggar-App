import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:aggar/features/settings/presentation/widgets/language_switch.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 0,
      backgroundColor: AppColors.myBlue100_7,
      child: Row(
        children: [
          const Image(
            image: AssetImage(
              AppAssets.assetsIconsLanguage,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Language",
            style: AppStyles.bold16(context).copyWith(
              color: AppColors.myBlue100_1,
            ),
          ),
          const Spacer(),
          const LanguageSwitch()
        ],
      ),
    );
  }
}
