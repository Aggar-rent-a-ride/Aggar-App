import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:aggar/core/utils/app_styles.dart';

class TermsCheck extends StatelessWidget {
  final bool isChecked;
  final Function(bool) onChanged;

  const TermsCheck({
    super.key,
    this.isChecked = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) => onChanged(value ?? false),
          activeColor: context.theme.blue100_2,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Terms and Conditions',
                  style: AppStyles.regular20(context),
                ),
                content: Text(
                  'Here are the terms and conditions...',
                  style: AppStyles.regular20(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: AppStyles.regular20(context),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Text(
            'terms and conditions',
            style: AppStyles.regular20(context).copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
