import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ArrowForwardIconButton extends StatelessWidget {
  const ArrowForwardIconButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        size: 20,
        color: AppColors.myBlue100_1,
        Icons.arrow_forward_ios_rounded,
      ),
    );
  }
}
