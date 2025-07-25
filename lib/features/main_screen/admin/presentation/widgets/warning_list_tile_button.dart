import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarningListTileButton extends StatelessWidget {
  const WarningListTileButton({
    super.key,
    required this.user,
    required this.accessToken,
  });

  final UserModel user;
  final String accessToken;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.warning_amber_rounded),
      title: Text(
        "Warning User",
        style: AppStyles.semiBold16(context).copyWith(
          color: context.theme.black100,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Warning User",
            actionTitle: "Warinig",
            subtitle:
                "Are you sure you want to send a warning to ${user.name} ?",
            onPressed: () {
              context.read<UserCubit>().punishUser(
                    accessToken,
                    user.id.toString(),
                    "Warning",
                    0,
                  );
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
