import 'package:aggar/features/settings/presentation/widgets/connect_with_us_section.dart';
import 'package:aggar/features/settings/presentation/widgets/meet_our_team_section.dart';
import 'package:aggar/features/settings/presentation/widgets/need_more_help_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: context.theme.white100_1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.theme.black100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Help Center',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Help Center!',
                style: AppStyles.bold18(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
              const Gap(8),
              Text(
                'Find answers to common questions, get support, and connect with our team. We\'re here to help you make the most of your experience.',
                style: AppStyles.regular16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              const Gap(32),
              const NeedMoreHelpSection(),
              const Gap(32),
              const MeetOurTeamSection(),
              const Gap(32),
              const ConnectWithUsSection(),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
