import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../settings/presentation/views/settings_screen.dart';

class EditProfileWithSettingsButtons extends StatelessWidget {
  const EditProfileWithSettingsButtons({
    super.key,
    required this.isRenter,
  });
  final bool isRenter;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            final tokenCubit = context.read<TokenRefreshCubit>();
            final token = await tokenCubit.ensureValidToken();
            if (token != null) {
              String? userId = await context.read<LoginCubit>().getUserId();
              if (userId != null) {
                await context
                    .read<EditUserInfoCubit>()
                    .fetchUserInfo(userId, token);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userId: userId,
                    ),
                  ),
                );
              }
            }
          },
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
                builder: (context) => SettingsScreen(
                  isRenter: isRenter,
                ),
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
            fixedSize: const Size(44, 44),
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
