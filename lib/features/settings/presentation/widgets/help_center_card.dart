import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';

import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';
import '../../presentation/views/help_center_screen.dart';

class HelpCenterCard extends StatelessWidget {
  const HelpCenterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 10,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
        );
      },
      backgroundColor: context.theme.blue100_1.withOpacity(0.05),
      child: Row(
        children: [
          Image(
            image: const AssetImage(
              AppAssets.assetsIconsHelpCenter,
            ),
            color: context.theme.blue100_1,
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Help Center",
            style: AppStyles.bold16(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
          const Spacer(),
          const ArrowForwardIconButton(),
        ],
      ),
    );
  }
}
