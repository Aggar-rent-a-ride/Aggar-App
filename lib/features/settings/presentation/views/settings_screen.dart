import 'package:aggar/core/widgets/horizontal_line.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:aggar/features/settings/presentation/widgets/image_with_name_and_email_section.dart';
import 'package:aggar/features/settings/presentation/widgets/payment_card.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            CustomCardSettingsPage(
              padingHorizental: 0,
              padingVeritical: 12,
              onPressed: () {},
              borderColor: AppColors.myBlue100_1,
              backgroundColor: Colors.transparent,
              child: const ImageWithNameAndEmailSection(),
            ),
            const Gap(12),
            const PaymentCard(),
            const Gap(12),
            const RentHistoryCard(),
            const Gap(5),
            const HorizontalLine(),
          ],
        ),
      ),
    );
  }
}
