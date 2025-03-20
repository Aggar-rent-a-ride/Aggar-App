import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:aggar/features/settings/presentation/widgets/image_with_name_and_email_section.dart';
import 'package:flutter/material.dart';

class PersonalDetailsCard extends StatelessWidget {
  const PersonalDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardSettingsPage(
      padingHorizental: 0,
      padingVeritical: 12,
      onPressed: () {},
      borderColor: AppLightColors.myBlue100_1,
      backgroundColor: Colors.transparent,
      child: const ImageWithNameAndEmailSection(),
    );
  }
}
