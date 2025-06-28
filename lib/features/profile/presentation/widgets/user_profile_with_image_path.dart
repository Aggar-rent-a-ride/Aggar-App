import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:aggar/features/profile/presentation/views/show_profile_screen.dart';
import 'package:flutter/material.dart';

class UserProfileWithImagePath extends StatelessWidget {
  const UserProfileWithImagePath({
    super.key,
    required this.widget,
  });

  final ShowProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: 0,
      right: 0,
      child: CircleAvatar(
        backgroundColor: context.theme.white100_1,
        radius: 50,
        child: CircleAvatar(
          radius: 45,
          child: AvatarChatView(
            image: widget.user.imagePath,
            size: 90,
          ),
        ),
      ),
    );
  }
}
