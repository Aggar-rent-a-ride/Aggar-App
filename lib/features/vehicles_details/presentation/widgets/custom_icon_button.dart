import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppLightColors.myWhite100_2,
          boxShadow: [
            BoxShadow(
              color: AppLightColors.myBlack25,
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 4,
            ),
          ],
        ),
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
      ),
    );
  }
}
