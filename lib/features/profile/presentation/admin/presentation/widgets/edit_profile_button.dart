import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../authorization/data/cubit/Login/login_cubit.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final tokenCubit = context.read<TokenRefreshCubit>();
        final token = await tokenCubit.getAccessToken();
        if (token != null) {
          String? userId = await context.read<LoginCubit>().getUserId();
          context.read<EditUserInfoCubit>().fetchUserInfo(userId!, token);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  userId: userId,
                ),
              ));
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
    );
  }
}
