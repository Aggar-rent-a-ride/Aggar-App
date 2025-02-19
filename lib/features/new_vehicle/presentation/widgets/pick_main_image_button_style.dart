import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PickMainImageButtonStyle extends StatelessWidget {
  const PickMainImageButtonStyle({
    super.key,
    required this.widget,
    this.onPressed,
  });
  final Widget widget;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: AppColors.myBlack25,
          offset: const Offset(0, 0),
          blurRadius: 4,
        )
      ]),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.all(AppColors.myBlue10_2),
          backgroundColor: WidgetStateProperty.all(
            AppColors.myBlue100_8,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 25,
            ),
          ),
        ),
        onPressed: onPressed,
        child: widget,
      ),
    );
  }
}
