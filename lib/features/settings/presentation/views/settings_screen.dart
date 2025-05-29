import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/horizontal_line.dart';
import 'package:aggar/features/settings/presentation/widgets/logout_card.dart';
import 'package:aggar/features/settings/presentation/widgets/payment_card.dart';
import 'package:aggar/features/settings/presentation/widgets/personal_details_card.dart';
import 'package:aggar/features/settings/presentation/widgets/rent_history_card.dart';
import 'package:aggar/features/settings/presentation/widgets/settings_and_preferences_section.dart';
import 'package:aggar/features/settings/presentation/widgets/support_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Settings',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(5),
              PersonalDetailsCard(),
              Gap(12),
              PaymentCard(),
              Gap(12),
              RentHistoryCard(),
              Gap(5),
              HorizontalLine(),
              Gap(5),
              SettingsAndPreferencesSection(),
              Gap(5),
              SupportSection(),
              Gap(5),
              LogoutCard(),
              Gap(50),
            ],
          ),
        ),
      ),
    );
  }
}
