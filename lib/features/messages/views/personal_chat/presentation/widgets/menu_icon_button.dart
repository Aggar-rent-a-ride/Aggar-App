import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_description_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({
    super.key,
    required this.cubit,
    required this.userId,
  });

  final PersonalChatCubit cubit;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero),
                ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          elevation: 1,
          color: context.theme.white100_2,
          context: context,
          position: position,
          items: [
            PopupMenuItem(
              value: "search",
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: context.theme.black100,
                  ),
                  const Gap(5),
                  Text(
                    "Search",
                    style: AppStyles.medium16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            PopupMenuItem(
              value: "report",
              child: Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: context.theme.black100,
                  ),
                  const Gap(5),
                  Text(
                    "Report",
                    style: AppStyles.medium16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
          ],
        ).then((value) async {
          if (value == "search") {
            cubit.toggleSearchMode();
          } else if (value == "report") {
            final tokenCubit = context.read<TokenRefreshCubit>();
            final token = await tokenCubit.ensureValidToken();
            if (token != null) {
              showDialog(
                context: context,
                builder: (context) => CustomDescriptionDialog(
                  type: "AppUser",
                  id: userId,
                  token: token,
                ),
              );
            }
          }
        });
      },
      icon: Icon(
        Icons.more_vert_outlined,
        color: context.theme.white100_2,
      ),
    );
  }
}
