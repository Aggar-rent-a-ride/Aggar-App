import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppUserTargetTypeCard extends StatelessWidget {
  const AppUserTargetTypeCard({
    super.key,
    required this.id,
    required this.name,
    this.imagePath,
  });

  final int id;
  final String name;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue10_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AvatarChatView(
              image: imagePath,
              size: 40,
            ),
            const Gap(12),
            Column(
              children: [
                Text(
                  name,
                  style: AppStyles.bold18(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
              ],
            ),
            const Spacer(),
            OptionsButton(
              user: UserModel(id: id, name: name, username: ""),
            )
          ],
        ),
      ),
    );
  }
}
