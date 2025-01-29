import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TermsCheck extends StatefulWidget {
  const TermsCheck({super.key});

  @override
  State<TermsCheck> createState() => _TermsCheckState();
}

class _TermsCheckState extends State<TermsCheck> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: AppColors.myBlue100_2,
          ),
          Text(
            'Agree to the ',
            style: AppStyles.regular20(context),
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
      ),
    );
  }
}
