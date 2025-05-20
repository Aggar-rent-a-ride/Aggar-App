import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/ban_list_tile_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/delete_list_tile_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/warning_list_tile_button.dart';
import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({
    super.key,
    required this.user,
  });
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        customShowModelBottmSheet(
            context,
            "Options",
            Column(
              children: [
                WarningListTileButton(user: user),
                BanListTileButton(user: user),
                DeleteListTileButton(user: user),
              ],
            ));
      },
      icon: const Icon(
        Icons.more_vert_rounded,
      ),
    );
  }
}
