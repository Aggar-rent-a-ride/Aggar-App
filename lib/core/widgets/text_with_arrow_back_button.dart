import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextWithArrowBackButton extends StatelessWidget {
  const TextWithArrowBackButton({
    super.key,
    required this.text,
    this.onPressed,
  });
  final String text;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
          ),
          overlayColor: WidgetStatePropertyAll(
            AppLightColors.myBlue10_2,
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: AppStyles.medium14(context).copyWith(
                color: AppLightColors.myBlue100_2,
              ),
            ),
            const Gap(10),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppLightColors.myBlue100_2,
            ),
          ],
        ),
      ),
    );
  }
}
