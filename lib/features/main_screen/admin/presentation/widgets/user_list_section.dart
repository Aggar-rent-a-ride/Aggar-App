import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/loading_users_section.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UserListSection extends StatelessWidget {
  const UserListSection({
    super.key,
    required this.title,
    required this.role,
    required this.accessToken,
    this.onPressed,
  });

  final String title;
  final String role;
  final String accessToken;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..getUserWithRole(accessToken, role),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const LoadingUsersSection();
          } else if (state is UserLoaded) {
            final users = state.users.data.take(4).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppStyles.bold22(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                    const Spacer(),
                    SeeMoreButton(onPressed: onPressed),
                  ],
                ),
                const Gap(10),
                if (users.isEmpty)
                  Text(
                    "No $title found",
                    style: AppStyles.regular16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  )
                else
                  Column(
                    children:
                        users.map((user) => UserCard(user: user)).toList(),
                  ),
              ],
            );
          } else if (state is UserError) {
            return Text(
              state.message,
              style: AppStyles.regular16(context).copyWith(
                color: context.theme.black100,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
