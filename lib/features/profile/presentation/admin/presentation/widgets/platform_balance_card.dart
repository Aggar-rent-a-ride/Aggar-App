import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/views/platform_balance_screen.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/cubit/refresh token/token_refresh_cubit.dart';
import '../../../../../payment/presentation/cubit/payment_cubit.dart';

class PlatformBalanceCard extends StatelessWidget {
  const PlatformBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 5,
      padingVeritical: 10,
      onPressed: () async {
        final tokenCubit = context.read<TokenRefreshCubit>();
        final token = await tokenCubit.getAccessToken();
        if (token != null) {
          context.read<PaymentCubit>().getPlatformBalance(token);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlatformBalanceScreen(),
            ),
          );
        }
      },
      backgroundColor: context.theme.blue100_7,
      child: Row(
        children: [
          Image(
            image: const AssetImage(
              AppAssets.assetsIconsBalance,
            ),
            color: context.theme.blue100_1,
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "PlatForm Balance",
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
