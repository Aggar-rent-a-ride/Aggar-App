import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/duration_ban_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanListTileButton extends StatelessWidget {
  BanListTileButton({
    super.key,
    required this.user,
    required this.accessToken,
  });

  final UserModel user;
  final String accessToken;
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.block),
      title: Text(
        "Ban User",
        style: AppStyles.semiBold16(context).copyWith(
          color: context.theme.black100,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: context.theme.white100_2,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            title: Text(
              "Ban User",
              style: AppStyles.semiBold24(context).copyWith(
                color: context.theme.black100,
              ),
            ),
            content: DurationBanTextField(
                user: user, durationController: durationController),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: AppStyles.semiBold15(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final duration = int.tryParse(durationController.text) ?? 0;
                  context.read<UserCubit>().punishUser(
                        accessToken,
                        user.id.toString(),
                        "Ban",
                        duration,
                      );
                  Navigator.pop(context);
                },
                child: Text(
                  "Ban",
                  style: AppStyles.semiBold15(context).copyWith(
                    color: context.theme.red100_1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
