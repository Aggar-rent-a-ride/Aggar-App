import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:aggar/features/settings/presentation/widgets/dark_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DarkModeCard extends StatelessWidget {
  const DarkModeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 1,
      backgroundColor: AppColors.myBlue100_7,
      child: Row(
        children: [
          const Image(
            image: AssetImage(
              AppAssets.assetsIconsDarkMode,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Dark Mode",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.myBlue100_1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const DarkModeSwitch()
        ],
      ),
    );
  }
}
