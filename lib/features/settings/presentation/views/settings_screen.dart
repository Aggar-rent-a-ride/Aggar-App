import 'package:aggar/core/widgets/horizontal_line.dart';
import 'package:aggar/features/settings/presentation/widgets/notification_settings_card.dart';
import 'package:aggar/features/settings/presentation/widgets/payment_card.dart';
import 'package:aggar/features/settings/presentation/widgets/personal_details_card.dart';
import 'package:aggar/features/settings/presentation/widgets/rent_history_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            PersonalDetailsCard(),
            Gap(12),
            PaymentCard(),
            Gap(12),
            RentHistoryCard(),
            Gap(5),
            HorizontalLine(),
            Gap(5),
            SettingsAndPreferencesSection()
          ],
        ),
      ),
    );
  }
}

class SettingsAndPreferencesSection extends StatelessWidget {
  const SettingsAndPreferencesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings and Preferences",
          style: TextStyle(
            color: AppColors.myBlue100_1,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(20),
        const NotificationSettingsCard(),
        const Gap(5),
      ],
    );
  }
}
