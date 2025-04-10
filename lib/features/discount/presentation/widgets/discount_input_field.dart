import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/discount/presentation/widgets/custom_suffix_widget.dart';
import 'package:flutter/material.dart';

class DiscountInputField extends StatelessWidget {
  final String hintText;
  final String suffixText;
  final TextEditingController controller;

  const DiscountInputField({
    super.key,
    required this.hintText,
    required this.suffixText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppStyles.medium15(context).copyWith(
        color: AppLightColors.myBlack100,
      ),
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppLightColors.myWhite100_1,
        hintStyle: AppStyles.medium15(context).copyWith(
          color: AppLightColors.myBlack50,
        ),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: AppLightColors.myBlack50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: AppLightColors.myBlue100_2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: AppLightColors.myBlack50,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        suffix: CustomSuffixWidget(suffixText: suffixText),
      ),
    );
  }
}
