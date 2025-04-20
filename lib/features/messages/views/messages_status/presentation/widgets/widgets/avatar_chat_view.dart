import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class AvatarChatView extends StatelessWidget {
  const AvatarChatView({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: context.theme.black25,
            spreadRadius: 0,
            blurRadius: 4,
          )
        ],
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(image),
      ),
    );
  }
}
