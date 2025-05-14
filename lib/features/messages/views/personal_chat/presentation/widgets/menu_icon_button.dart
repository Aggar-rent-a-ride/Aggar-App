import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:flutter/material.dart';

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
          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
          items: [
            PopupMenuItem(
              value: "search",
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: context.theme.black100,
                  ),
                  const SizedBox(width: 5),
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
          ],
        ).then((value) {
          if (value == "search") {
            cubit.toggleSearchMode();
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
