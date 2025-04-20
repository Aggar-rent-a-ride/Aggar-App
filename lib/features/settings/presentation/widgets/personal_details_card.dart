import 'package:aggar/core/extensions/context_colors_extension.dart';
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
      borderColor: context.theme.blue100_1,
      backgroundColor: Colors.transparent,
      child: const ImageWithNameAndEmailSection(),
    );
  }
}
