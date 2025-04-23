import 'package:aggar/core/extensions/context_colors_extension.dart';
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
        color: context.theme.black100,
      ),
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: AppStyles.medium15(context).copyWith(
          color: context.theme.black50,
        ),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: context.theme.gray100_2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: context.theme.blue100_2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: context.theme.gray100_2,
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
