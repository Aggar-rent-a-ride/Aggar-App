import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddVehicleTypeOrBrandButton extends StatelessWidget {
  const AddVehicleTypeOrBrandButton({
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
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: 20,
              color: context.theme.blue100_1,
            ),
            const Gap(5),
            Text(
              text,
              style: AppStyles.semiBold14(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
