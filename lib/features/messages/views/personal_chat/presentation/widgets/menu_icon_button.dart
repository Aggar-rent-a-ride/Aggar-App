import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({
    super.key,
    required this.cubit,
  });

  final PersonalChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showMenu(
          elevation: 1,
          color: context.theme.white100_2,
          context: context,
          position: RelativeRect.fill,
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
        ).then((value) {
          if (value == "search") {
            cubit.toggleSearchMode();
          } else if (value == "report") {
            /* showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  title: 'Report Vehicle',
                  subtitle: 'Are you sure you want to report this user ?',
                  actionTitle: 'Yes',
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => CustomDescriptionDialog(
                        type: "AppUSer",
                        id: ,
                        token: token,
                      ),
                    );
                  },
                ),
              );*/
          }
        });
      },
      icon: Icon(
        color: context.theme.white100_2,
        Icons.more_vert_outlined,
      ),
    );
  }
}
