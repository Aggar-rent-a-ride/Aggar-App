import 'package:flutter/material.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';

class RadioButtons extends StatelessWidget {
  const RadioButtons({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  final int? selectedValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Radio<int>(
                fillColor: WidgetStateProperty.all(AppColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 2,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(2),
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
                fillColor: WidgetStateProperty.all(AppColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 1,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(1),
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
                fillColor: WidgetStateProperty.all(AppColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(0),
              ),
              Text(
                'None',
                style: AppStyles.medium15(context).copyWith(
                  color: AppColors.myBlue100_1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
