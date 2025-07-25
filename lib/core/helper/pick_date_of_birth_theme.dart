import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

Widget pickDateOfBirthTheme(BuildContext context, Widget? child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: context.theme.blue100_1,
            onPrimary: AppConstants.myWhite100_1,
            surface: context.theme.black100,
            onSurface: context.theme.black100,
            error: context.theme.red100_1,
          ),
      scaffoldBackgroundColor: context.theme.white100_1,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: context.theme.white100_1,
        dialBackgroundColor: context.theme.white100_1,
        hourMinuteTextColor: context.theme.black100,
        hourMinuteColor: context.theme.white100_1,
        dayPeriodTextColor: context.theme.black100,
        dayPeriodColor: context.theme.blue100_1,
        dialHandColor: context.theme.blue100_1,
        dialTextColor: context.theme.black100,
        timeSelectorSeparatorTextStyle: WidgetStateProperty.all(
          AppStyles.bold36(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        timeSelectorSeparatorColor:
            WidgetStateProperty.all(context.theme.black100),
        entryModeIconColor: context.theme.black100,
        helpTextStyle: AppStyles.regular16(context).copyWith(
          color: context.theme.black100,
        ),
        hourMinuteTextStyle: AppStyles.bold36(context).copyWith(
          color: context.theme.black100,
        ),
        dayPeriodTextStyle: AppStyles.regular16(context).copyWith(
          color: context.theme.black100,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        dayStyle: AppStyles.regular16(context).copyWith(
          color: context.theme.black100,
        ),
        yearStyle: AppStyles.regular16(context).copyWith(
          color: context.theme.black100,
        ),
        headerHelpStyle: AppStyles.regular16(context).copyWith(
          color: context.theme.black100,
        ),
        weekdayStyle: AppStyles.regular16(context).copyWith(
          color: context.theme.black100,
        ),
        headerHeadlineStyle: AppStyles.bold24(context).copyWith(
          color: context.theme.black100,
        ),
        dividerColor: context.theme.grey100_1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: context.theme.white100_1,
        headerBackgroundColor: context.theme.white100_1,
      ),
    ),
    child: child!,
  );
}
