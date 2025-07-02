import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_state.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameWithUserName extends StatelessWidget {
  const NameWithUserName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserInfoSuccess) {
          final user = state.userInfoModel;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: AppStyles.bold24(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
                Text(
                  user.userName,
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Unknown",
                  style: AppStyles.bold24(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
                Text(
                  "Unknown",
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
