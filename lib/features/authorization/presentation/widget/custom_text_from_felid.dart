import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.labelText,
      this.hintText,
      this.initialValue,
      this.validator,
      this.onChanged,
      this.controller,
      required this.inputType,
      this.suffixIcon,
      required this.obscureText});

  final String labelText;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            labelText,
            style: AppStyles.medium20(context),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            style: AppStyles.regular16(context).copyWith(
              color: AppColors.myBlack50,
            ),
            textAlign: TextAlign.start,
            keyboardType: inputType,
            initialValue: initialValue,
            validator: validator,
            onChanged: onChanged,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppStyles.regular16(context).copyWith(
                  color: AppColors.myBlack50,
                ),
                filled: true,
                fillColor: AppColors.myWhite100_3,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 19,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: suffixIcon != null
                    ? IconButton(
                        icon: suffixIcon!,
                        onPressed: () {
                          // Add your onPressed code here
                        },
                      )
                    : null),
          ),
        ),
      ],
    );
  }
}
