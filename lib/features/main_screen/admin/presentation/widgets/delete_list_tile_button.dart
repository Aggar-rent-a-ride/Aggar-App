import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteListTileButton extends StatelessWidget {
  const DeleteListTileButton({
    super.key,
    required this.user,
    required this.accessToken,
  });

  final UserModel user;
  final String accessToken;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete),
      title: Text(
        "Delete User",
        style: AppStyles.semiBold16(context).copyWith(
          color: context.theme.black100,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Delete User",
            actionTitle: "Delete",
            subtitle: "Are you sure you want to delete ${user.name} ?",
            onPressed: () {
              context.read<UserCubit>().deleteUser(
                    accessToken,
                    user.id,
                  );
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
