import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/no_search_result_body.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/no_users_found_body.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SearchResultSection extends StatelessWidget {
  const SearchResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 100, color: Colors.red),
                const Gap(16),
                Text(
                  state.message,
                  style:
                      AppStyles.medium16(context).copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded) {
          final users = state.users.data;
          if (users.isEmpty) {
            return const NoUsersFoundBody();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Results (${cubit.totalPages} users)',
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserSearchCard(user: user);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserNoSearch) {
          return const NoSearchResultBody();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 100, color: Colors.grey),
              const Gap(16),
              Text(
                'Search for users',
                style: AppStyles.medium16(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
