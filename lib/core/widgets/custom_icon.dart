import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    this.icon,
    this.color = Colors.black,
    this.size = 25,
    required this.flag,
    this.imageIcon,
    required this.hight,
    required this.width,
  });
  final IconData? icon;
  final Color? color;
  final double? size;
  final bool flag;
  final String? imageIcon;
  final double hight;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hight,
      width: width,
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
              color: color,
              height: size,
            ),
    );
  }
}
