import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

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
                fillColor: WidgetStateProperty.all(AppLightColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 2,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    print("Manual selected");
                    onChanged(value);
                  }
                },
              ),
              Text(
                'Manual Transmission',
                style: AppStyles.medium15(context).copyWith(
                  color: AppLightColors.myBlue100_1,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                fillColor: WidgetStateProperty.all(AppLightColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 1,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    print("Automatic selected");
                    onChanged(value);
                  }
                },
              ),
              Text(
                'Automatic Transmission',
                style: AppStyles.medium15(context).copyWith(
                  color: AppLightColors.myBlue100_1,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                fillColor: WidgetStateProperty.all(AppLightColors.myBlue100_2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    print("None selected");
                    onChanged(value);
                  }
                },
              ),
              Text(
                'None',
                style: AppStyles.medium15(context).copyWith(
                  color: AppLightColors.myBlue100_1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
