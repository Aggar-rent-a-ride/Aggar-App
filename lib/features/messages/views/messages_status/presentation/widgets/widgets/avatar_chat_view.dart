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
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            color: Colors.black12,
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
