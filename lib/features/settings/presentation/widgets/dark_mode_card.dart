import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
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
      backgroundColor: context.theme.blue100_1.withOpacity(0.1),
      child: Row(
        children: [
          Image(
            image: const AssetImage(
              AppAssets.assetsIconsDarkMode,
            ),
            color: context.theme.blue100_1,
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Dark Mode",
            style: AppStyles.bold16(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
          const Spacer(),
          const DarkModeSwitch()
        ],
      ),
    );
  }
}
