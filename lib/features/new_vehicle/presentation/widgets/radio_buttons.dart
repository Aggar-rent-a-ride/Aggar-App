import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class RadioButtons extends StatelessWidget {
  const RadioButtons({
    super.key,
    required int selectedValue,
  }) : _selectedValue = selectedValue;

  final int _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Radio<int>(
                fillColor: WidgetStatePropertyAll(AppColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                groupValue: _selectedValue,
                onChanged: (int? value) {},
              ),
              Text(
                'Manual Transmission',
                style: AppStyles.medium15(context).copyWith(
                  color: AppColors.myBlue100_1,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                fillColor: WidgetStatePropertyAll(AppColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                groupValue: _selectedValue,
                onChanged: (int? value) {},
              ),
              Text(
                'Automatic Transmission',
                style: AppStyles.medium15(context).copyWith(
                  color: AppColors.myBlue100_1,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                fillColor: WidgetStatePropertyAll(AppColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 1,
                groupValue: _selectedValue,
                onChanged: (int? value) {},
              ),
              Text(
                'None',
                style: AppStyles.medium15(context).copyWith(
                  color: AppColors.myBlue100_1,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
