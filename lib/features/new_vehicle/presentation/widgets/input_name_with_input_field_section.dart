import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class InputNameWithInputFieldSection extends StatelessWidget {
  const InputNameWithInputFieldSection({
    super.key,
    required this.label,
    required this.hintText,
    this.width,
    this.widget,
    this.foundIcon = false,
    this.maxLines = 1,
    this.controller,
    this.validator,
  });
  final String label;
  final String hintText;
  final double? width;
  final Widget? widget;
  final bool? foundIcon;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        SizedBox(
          width: width ?? MediaQuery.of(context).size.width * 0.3,
          child: TextFormField(
            validator: validator,
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.myRed100_1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: AppColors.myRed100_1,
              )),
              errorStyle: AppStyles.regular14(context).copyWith(
                color: AppColors.myRed100_1,
              ),
              hintText: hintText,
              hintStyle: AppStyles.medium15(context).copyWith(
                color: AppColors.myBlack50,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              fillColor: AppColors.myWhite100_1,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack50,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack50,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack50,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              suffix: foundIcon == true ? widget : const SizedBox(),
            ),
            style: AppStyles.medium15(context).copyWith(
              color: AppColors.myBlack100,
            ),
          ),
        )
      ],
    );
  }
}
