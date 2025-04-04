import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 50;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 4,
          )
        ],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: MaterialButton(
          padding: EdgeInsets.zero,
          elevation: 0,
          color: AppLightColors.myBlue100_2,
          splashColor: AppLightColors.myWhite50_1,
          highlightColor: AppLightColors.myWhite50_1,
          shape: const CircleBorder(),
          onPressed: onPressed,
          child: Icon(
            Icons.add,
            size: MediaQuery.sizeOf(context).height * 0.03,
            color: AppLightColors.myWhite100_1,
          ),
        ),
      ),
    );
  }
}
