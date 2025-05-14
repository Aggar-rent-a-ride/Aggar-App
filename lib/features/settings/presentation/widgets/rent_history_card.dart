import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class RentHistoryCard extends StatelessWidget {
  const RentHistoryCard({
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
            MaterialPageRoute(
              builder: (context) => const RentHistoryView(),
            ));
      },
      backgroundColor: context.theme.blue100_7,
      child: Row(
        children: [
          const Image(
            image: AssetImage(
              AppAssets.assetsIconsRentHistory,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Rent history",
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
