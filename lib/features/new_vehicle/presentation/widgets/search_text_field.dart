import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
  });

  final TextEditingController textEditingController;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppStyles.medium15(context).copyWith(
        color: context.theme.blue100_2,
      ),
      controller: textEditingController,
      decoration: InputDecoration(
        focusColor: context.theme.blue100_2,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.theme.blue100_2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: hintText,
        hintStyle: AppStyles.medium15(context).copyWith(
          color: context.theme.black50,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: context.theme.blue100_2,
          ),
        ),
      ),
    );
  }
}
