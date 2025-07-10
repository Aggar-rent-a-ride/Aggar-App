import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.onPressed,
    required this.actionTitle,
    required this.subtitle,
    this.textColor,
    this.buttonColor,
  });
  final String title;
  final String actionTitle;
  final String subtitle;
  final void Function()? onPressed;
  final Color? textColor;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: context.theme.white100_2,
      title: Text(
        title,
        style: AppStyles.semiBold24(context).copyWith(
          color: context.theme.black100,
        ),
      ),
      content: Text(
        subtitle,
        style: AppStyles.medium18(context).copyWith(
          color: context.theme.black50,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppStyles.bold15(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
        ),
        TextButton(
          style:
              ButtonStyle(backgroundColor: WidgetStatePropertyAll(buttonColor)),
          onPressed: onPressed,
          child: Text(
            actionTitle,
            style: AppStyles.semiBold15(context).copyWith(
              color: textColor ?? context.theme.red100_1,
            ),
          ),
        ),
      ],
    );
  }
}
