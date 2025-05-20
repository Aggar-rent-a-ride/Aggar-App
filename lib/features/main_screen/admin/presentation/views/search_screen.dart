import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/search_result_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.white100_1,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.blue100_8,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 55, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.white100_2,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: cubit.searchController,
                      onChanged: (value) {
                        cubit.searchUsers(
                            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImM1ZmJjNWMwLTAwNGEtNDQ1Yi05YjUyLTQ3NzQzMjJjNTk5OCIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NzI3MDg5LCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.Odtpj7oo5b_i1eW21ZiGwQBN3dHbNiL4RgUZue2xwtI',
                            value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for user',
                        hintStyle: AppStyles.regular18(context).copyWith(
                          color: context.theme.black100.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: context.theme.black100.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: SearchResultSection(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
