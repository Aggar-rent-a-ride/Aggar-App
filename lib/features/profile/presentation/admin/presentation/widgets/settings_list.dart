import 'package:aggar/features/profile/presentation/admin/presentation/widgets/platform_balance_card.dart';
import 'package:aggar/features/settings/presentation/widgets/contact_us_card.dart';
import 'package:aggar/features/settings/presentation/widgets/dark_mode_card.dart';
import 'package:aggar/features/settings/presentation/widgets/help_center_card.dart';
import 'package:aggar/features/settings/presentation/widgets/language_card.dart';
import 'package:aggar/features/settings/presentation/widgets/logout_card.dart';
import 'package:flutter/material.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        spacing: 12,
        children: [
          PlatformBalanceCard(),
          LanguageCard(),
          DarkModeCard(),
          HelpCenterCard(),
          ContactUsCard(),
          LogoutCard(),
        ],
      ),
    );
  }
}
