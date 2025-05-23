import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          UserImage(user: user),
          const Gap(10),
          Text(
            user.name,
            style: AppStyles.bold18(context).copyWith(
              color: context.theme.black100,
            ),
          ),
          const Spacer(),
          /* OptionsButton(
            user: user,
          )*/
        ],
      ),
    );
  }
}
