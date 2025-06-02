import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'custom_dropdown_field.dart';

class DateTimeRow extends StatelessWidget {
  final String dateLabel;
  final String timeLabel;
  final String selectedDate;
  final String selectedTime;
  final String datePlaceholder;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;
  final Color? timeIconColor;

  const DateTimeRow({
    super.key,
    required this.dateLabel,
    required this.timeLabel,
    required this.selectedDate,
    required this.selectedTime,
    required this.datePlaceholder,
    required this.onDateTap,
    required this.onTimeTap,
    this.timeIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDropdownField(
            label: dateLabel,
            value: selectedDate,
            placeholder: datePlaceholder,
            onTap: onDateTap,
          ),
        ),
        const Gap(16),
        Expanded(
          child: CustomDropdownField(
            label: timeLabel,
            value: selectedTime,
            placeholder: selectedTime,
            onTap: onTimeTap,
            iconColor: timeIconColor,
          ),
        ),
      ],
    );
  }
}
