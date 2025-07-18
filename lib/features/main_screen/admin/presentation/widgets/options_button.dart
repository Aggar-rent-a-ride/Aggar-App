import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/ban_list_tile_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/delete_list_tile_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/warning_list_tile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({
    super.key,
    required this.user,
    this.color,
    this.size,
  });
  final UserModel user;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminMainCubit, AdminMainState>(
      builder: (context, state) {
        if (state is AdminMainConnected) {
          return IconButton(
            onPressed: () {
              customShowModelBottmSheet(
                  context,
                  "Options",
                  Column(
                    children: [
                      WarningListTileButton(
                        user: user,
                        accessToken: state.accessToken,
                      ),
                      BanListTileButton(
                        user: user,
                        accessToken: state.accessToken,
                      ),
                      DeleteListTileButton(
                        user: user,
                        accessToken: state.accessToken,
                      ),
                    ],
                  ));
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: color ?? context.theme.black50,
              size: size ?? 25,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
