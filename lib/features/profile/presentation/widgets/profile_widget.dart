import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/data/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileWidget extends StatelessWidget {
  final Profile profile;

  const ProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(profile.avatarAsset),
        ),
        const Gap(10),
        Text(profile.name, style: AppStyles.bold24(context)),
        Text(
          profile.role,
          style: AppStyles.regular20(context).copyWith(
            color: context.theme.gray100_2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            profile.description,
            textAlign: TextAlign.center,
            style: AppStyles.medium16(context),
          ),
        ),
      ],
    );
  }
}
