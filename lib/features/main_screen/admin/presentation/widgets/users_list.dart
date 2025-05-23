import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/role_user_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key, required this.accessToken});
  final String accessToken;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserListSection(
            title: "Admins",
            role: "Admin",
            accessToken: accessToken,
            onPressed: () {
              context.read<UserCubit>().getUserWithRole(accessToken, "Admin");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoleUserScreen(
                      accessToken: accessToken,
                      role: "Admin",
                    ),
                  ));
            },
          ),
          UserListSection(
            title: "Renters",
            role: "Renter",
            accessToken: accessToken,
            onPressed: () {
              context.read<UserCubit>().getUserWithRole(accessToken, "Renter");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoleUserScreen(
                      accessToken: accessToken,
                      role: "Renter",
                    ),
                  ));
            },
          ),
          UserListSection(
            title: "Customers",
            role: "Customer",
            accessToken: accessToken,
            onPressed: () {
              context
                  .read<UserCubit>()
                  .getUserWithRole(accessToken, "Customer");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoleUserScreen(
                      role: "Customer",
                      accessToken: accessToken,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
