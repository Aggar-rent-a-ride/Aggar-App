import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.lableText,
      this.hintText,
      this.initialValue,
      this.validator,
      this.onChanged,
      this.controller,
      required this.inputType,
      this.suffixIcon,
      required this.obscureText});

  final String lableText;
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
            lableText,
            style: GoogleFonts.inter(
              color: AppColors.myBlack100,
              fontSize: getFontSize(context, 20),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 4, // Shadow blur radius
                offset: const Offset(0, 4), // Shadow offset
              ),
            ],
          ),
          child: TextFormField(
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.myBlack100,
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
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.myGray100_4,
                ),
                filled: true,
                fillColor: AppColors.myWhite100_3,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 19),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: suffixIcon),
          ),
        ),
      ],
    );
  }
}
