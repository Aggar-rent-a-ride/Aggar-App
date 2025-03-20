import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/contact_us_card.dart';
import 'package:aggar/features/settings/presentation/widgets/help_center_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/horizontal_line.dart';

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
          style: AppStyles.bold18(context).copyWith(
            color: AppLightColors.myBlue100_1,
          ),
        ),
        const Gap(20),
        const HelpCenterCard(),
        const Gap(12),
        const ContactUsCard(),
        const Gap(5),
        const HorizontalLine(),
        const Gap(5),
      ],
    );
  }
}
