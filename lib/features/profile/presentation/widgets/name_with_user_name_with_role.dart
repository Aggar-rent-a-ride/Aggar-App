import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NameWithUserNameWithRole extends StatelessWidget {
  const NameWithUserNameWithRole({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoSuccess) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.userInfoModel.name,
                  style: AppStyles.bold24(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.userInfoModel.userName,
                      style: AppStyles.medium18(context).copyWith(
                        color: context.theme.gray100_2,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      "(${state.userInfoModel.role})",
                      style: AppStyles.semiBold16(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
