import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/horizontal_line.dart';
import 'package:aggar/features/settings/presentation/widgets/dark_mode_card.dart';
import 'package:aggar/features/settings/presentation/widgets/language_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

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
          style: AppStyles.bold18(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        const Gap(20),
        // const NotificationSettingsCard(),
        // const Gap(12),
        const LanguageCard(),
        const Gap(12),
        const DarkModeCard(),
        const Gap(5),
        const HorizontalLine(),
        const Gap(5),
      ],
    );
  }
}
