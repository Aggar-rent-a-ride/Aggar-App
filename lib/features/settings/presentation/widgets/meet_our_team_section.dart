import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/settings/presentation/widgets/team_member.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MeetOurTeamSection extends StatelessWidget {
  const MeetOurTeamSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meet Our Team',
          style: AppStyles.semiBold18(context)
              .copyWith(color: context.theme.black100),
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TeamMember(
              name: 'Esraa Ehab',
              role: 'Flutter Developer',
              color: context.theme.blue100_1,
              imagePath: AppAssets.assetsImagesEsraa,
            ),
            TeamMember(
              name: 'Ali Dosoqi',
              role: 'Flutter Developer',
              color: context.theme.blue100_1,
              imagePath: AppAssets.assetsImagesAli,
            ),
            TeamMember(
              name: 'Omar Elnaggar',
              role: 'Software Engineer',
              color: context.theme.blue100_1,
              imagePath: AppAssets.assetsImagesOmar,
            ),
            TeamMember(
              name: 'Mohamed Said',
              role: 'Software Engineer',
              color: context.theme.blue100_1,
              imagePath: AppAssets.assetsImagesMohamed,
            ),
          ],
        ),
      ],
    );
  }
}
