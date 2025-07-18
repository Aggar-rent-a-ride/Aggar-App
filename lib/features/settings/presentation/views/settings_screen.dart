import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/horizontal_line.dart';
import 'package:aggar/features/settings/presentation/widgets/logout_card.dart';
import 'package:aggar/features/settings/presentation/widgets/payment_card.dart';
import 'package:aggar/features/settings/presentation/widgets/payout_details_card.dart';
import 'package:aggar/features/settings/presentation/widgets/profile_details_card.dart';
import 'package:aggar/features/settings/presentation/widgets/rent_history_card.dart';
import 'package:aggar/features/settings/presentation/widgets/settings_and_preferences_section.dart';
import 'package:aggar/features/settings/presentation/widgets/support_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileAndSettingsScreen extends StatelessWidget {
  const ProfileAndSettingsScreen({
    super.key,
    required this.isRenter,
  });
  final bool isRenter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: context.theme.black100,
        ),
        elevation: 2,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Profile & Settings',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: AppStyles.bold18(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                  const Gap(12),
                  const ProfileDetailsCard(),
                ],
              ),
              const Gap(15),
              if (isRenter == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Financial",
                      style: AppStyles.bold18(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                    const Gap(12),
                    const PaymentCard(),
                    const Gap(12),
                    const PayoutDetailsCard(),
                    const Gap(12),
                    const RentHistoryCard(),
                  ],
                ),
              if (isRenter == false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Financial",
                      style: AppStyles.bold18(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                    const Gap(12),
                    const RentHistoryCard(),
                  ],
                ),
              const Gap(10),
              const HorizontalLine(),
              const Gap(10),
              const SettingsAndPreferencesSection(),
              const Gap(5),
              const SupportSection(),
              const Gap(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account",
                    style: AppStyles.bold18(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                  const Gap(12),
                  const LogoutCard(),
                ],
              ),
              const Gap(50),
            ],
          ),
        ),
      ),
    );
  }
}
