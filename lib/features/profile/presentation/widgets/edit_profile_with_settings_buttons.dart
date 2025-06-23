import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../settings/presentation/views/settings_screen.dart';

class EditProfileWithSettingsButtons extends StatelessWidget {
  const EditProfileWithSettingsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            backgroundColor: context.theme.white100_1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: context.theme.black25,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Edit Profile',
            style: AppStyles.medium18(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ),
        const Gap(5),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: context.theme.white100_1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: context.theme.black25,
                width: 1,
              ),
            ),
            fixedSize: const Size(40, 40),
          ),
          child: Icon(
            Icons.settings,
            color: context.theme.black50,
            size: 26,
          ),
        ),
      ],
    );
  }
}
