import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    this.icon,
    this.color = Colors.black,
    this.size = 25,
    required this.flag,
    this.imageIcon,
  });
  final IconData? icon;
  final Color? color;
  final double? size;
  final bool flag;
  final String? imageIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(8),
      
      child: flag == true
          ? Icon(
              icon,
              size: size,
              color: color,
            )
          : Image(
              image: AssetImage(
                imageIcon!,
              ),
              height: size,
            ),
    );
  }
}
