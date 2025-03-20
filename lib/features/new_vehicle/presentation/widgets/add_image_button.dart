import 'package:aggar/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 4,
          )
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(AppLightColors.myBlue100_2),
          overlayColor: WidgetStateProperty.all(
            AppLightColors.myWhite50_1,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        icon: Icon(
          Icons.add,
          size: MediaQuery.sizeOf(context).height * 0.03,
          color: AppLightColors.myWhite100_1,
        ),
      ),
    );
  }
}
