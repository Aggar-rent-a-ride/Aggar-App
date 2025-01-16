import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/settings/presentation/widgets/contact_us_card.dart';
import 'package:aggar/features/settings/presentation/widgets/help_center_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        const Gap(5),
        const HorizontalLine(),
        const Gap(5),
      ],
    );
  }
}
