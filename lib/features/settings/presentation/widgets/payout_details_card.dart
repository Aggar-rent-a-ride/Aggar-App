import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:aggar/features/settings/presentation/views/payout_details_screen.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PayoutDetailsCard extends StatelessWidget {
  const PayoutDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 10,
      onPressed: () async {
        final tokenRefreshCubit = context.read<TokenRefreshCubit>();
        final token = await tokenRefreshCubit.ensureValidToken();
        if (token != null) {
          context.read<PaymentCubit>().getRenterPayoutDetails(token);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PayoutDetailsScreen()),
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
            "Payout Details",
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
