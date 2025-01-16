import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/core/widgets/horizontal_line.dart';
import 'package:aggar/features/settings/presentation/widgets/payment_card.dart';
import 'package:aggar/features/settings/presentation/widgets/personal_details_card.dart';
import 'package:aggar/features/settings/presentation/widgets/rent_history_card.dart';
import 'package:aggar/features/settings/presentation/widgets/settings_and_preferences_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../widgets/arrow_forward_icon_button.dart';
import '../widgets/custom_card_settings_page.dart';

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
            SettingsAndPreferencesSection(),
            Gap(5),
            SupportSection()
          ],
        ),
      ),
    );
  }
}

class SupportSection extends StatelessWidget {
  const SupportSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Support",
          style: TextStyle(
            color: AppColors.myBlue100_1,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(20),
        const HelpCenterCard(),
        const Gap(12),
        const ContactUsCard(),
      ],
    );
  }
}

class ContactUsCard extends StatelessWidget {
  const ContactUsCard({
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
              AppAssets.assetsIconsContactUs,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Contact us",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.myBlue100_1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const CustomIcon(
            flag: false,
            hight: 15,
            width: 15,
            imageIcon: AppAssets.assetsIconsContactUsLink,
          )
        ],
      ),
    );
  }
}

class HelpCenterCard extends StatelessWidget {
  const HelpCenterCard({
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
              AppAssets.assetsIconsHelpCenter,
            ),
            height: 25,
            width: 25,
          ),
          const Gap(10),
          Text(
            "Help Center",
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
