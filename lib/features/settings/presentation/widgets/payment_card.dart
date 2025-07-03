import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/payment/presentation/views/connected_account_page.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
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
                builder: (context) => const ConnectedAccountPage()));
      },
      backgroundColor: context.theme.blue100_7,
      child: Row(
        children: [
          Image(
            image: const AssetImage(
              AppAssets.assetsIconsPayment,
            ),
            color: context.theme.blue100_1,
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Payment",
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
