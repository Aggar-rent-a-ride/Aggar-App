import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class ArrowForwardIconButton extends StatelessWidget {
  const ArrowForwardIconButton({
    super.key,
    this.onPressed,
    this.icon,
  });
  final void Function()? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      size: 20,
      color: context.theme.blue100_1,
      Icons.arrow_forward_ios_rounded,
    );
  }
}
