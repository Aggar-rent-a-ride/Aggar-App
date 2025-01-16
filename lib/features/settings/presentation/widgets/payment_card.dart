import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 10,
      onPressed: () {},
      backgroundColor: AppColors.myBlue100_7,
      child: Row(
        children: [
          const Image(
            image: AssetImage(
              AppAssets.assetsIconsPayment,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Payment",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.myBlue100_1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const ArrowForwardIconButton(),
        ],
      ),
    );
  }
}
