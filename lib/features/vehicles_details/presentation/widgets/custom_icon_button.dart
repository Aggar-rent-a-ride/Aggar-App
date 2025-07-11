import 'package:aggar/core/extensions/context_colors_extension.dart';
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
          color: context.theme.white100_2,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
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
