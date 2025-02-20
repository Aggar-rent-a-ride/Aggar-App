import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/radio_buttons.dart';
import 'package:flutter/material.dart';

class TransmissionModeOptions extends StatelessWidget {
  const TransmissionModeOptions({
    super.key,
    required int selectedValue,
  }) : _selectedValue = selectedValue;

  final int _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "transmission mode :",
            style: AppStyles.medium18(context).copyWith(
              color: AppColors.myBlue100_1,
            ),
          ),
        ),
        RadioButtons(selectedValue: _selectedValue)
      ],
    );
  }
}
