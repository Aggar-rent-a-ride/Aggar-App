import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
  });
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.myWhite100_2,
        boxShadow: [
          BoxShadow(
            color: AppColors.myBlack25,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 25,
        color: AppColors.myBlack100,
      ),
    );
  }
}
