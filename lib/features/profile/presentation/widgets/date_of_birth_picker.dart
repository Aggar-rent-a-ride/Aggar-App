import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/pick_date_of_birth_theme.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DateOfBirthPicker extends StatefulWidget {
  const DateOfBirthPicker({
    super.key,
    required this.controller,
    this.validator,
    this.onDateSelected,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onDateSelected;

  @override
  State<DateOfBirthPicker> createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  String? _validateDateFormat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }

    try {
      final date = DateTime.parse(value);

      final maxDate = DateTime(2025, 1, 13);
      if (date.isAfter(maxDate)) {
        return 'Date of birth cannot be after January 13, 2025';
      }

      final minDate = maxDate.subtract(const Duration(days: 365 * 13));
      if (date.isAfter(minDate)) {
        return 'You must be at least 13 years old as of January 13, 2025';
      }
    } catch (e) {
      return 'Please select a valid date';
    }

    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(widget.controller.text) ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025, 1, 13),
      builder: (context, child) => pickDateOfBirthTheme(context, child),
    );

    if (picked != null) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      widget.controller.text = formattedDate;
      widget.onDateSelected?.call(formattedDate);
      setState(() {}); // Trigger rebuild to update display
    }
  }

  DateTime? _parseDate(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  String _formatDateDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "Select your date of birth";
    }

    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    } catch (e) {
      return "Select your date of birth";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator ?? _validateDateFormat,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Date of Birth",
                style: AppStyles.medium20(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                  state.didChange(widget.controller.text);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 19,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: context.theme.black10,
                    border: state.hasError
                        ? Border.all(
                            color: context.theme.red100_1,
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDateDisplay(widget.controller.text),
                        style: AppStyles.regular16(context).copyWith(
                          color: widget.controller.text.isEmpty
                              ? context.theme.black50
                              : context.theme.black100,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: context.theme.black50,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: context.theme.red100_1,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
