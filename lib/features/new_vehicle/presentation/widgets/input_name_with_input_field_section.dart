import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class InputNameWithInputFieldSection extends StatelessWidget {
  const InputNameWithInputFieldSection({
    super.key,
    required this.label,
    required this.hintText,
    this.width,
  });
  final String label;
  final String hintText;
  final double? width;
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
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppStyles.medium15(context).copyWith(
                color: AppColors.myBlack50,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              fillColor: AppColors.myWhite100_1,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
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
