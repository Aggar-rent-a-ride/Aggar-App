import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/search_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/role_user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleUserScreen extends StatelessWidget {
  const RoleUserScreen(
      {super.key, required this.accessToken, required this.role});
  final String accessToken;
  final String role;

  @override
  Widget build(BuildContext context) {
    // Trigger initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().getUserWithRole(accessToken, role);
    });
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: Column(
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
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 55, bottom: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: context.theme.white100_1,
                    size: 20,
                  ),
                ),
                Text(
                  role,
                  style: AppStyles.bold20(context).copyWith(
                    color: context.theme.white100_1,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserSearchScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: context.theme.white100_1,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RoleUserList(accessToken: accessToken, role: role),
          ),
        ],
      ),
    );
  }
}
