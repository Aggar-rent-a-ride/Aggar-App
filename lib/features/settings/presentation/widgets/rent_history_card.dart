import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class RentHistoryCard extends StatelessWidget {
  const RentHistoryCard({super.key, required this.isRenter});
  final bool isRenter;

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 10,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentHistoryView(isRenter: isRenter),
          ),
        );
      },
      backgroundColor: context.theme.blue100_1.withOpacity(0.05),
      child: Row(
        children: [
          Image(
            image: const AssetImage(AppAssets.assetsIconsRentHistory),
            color: context.theme.blue100_1,
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Rent history",
            style: AppStyles.bold16(
              context,
            ).copyWith(color: context.theme.blue100_1),
          ),
          const Spacer(),
          const ArrowForwardIconButton(),
        ],
      ),
    );
  }
}
