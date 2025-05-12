import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';

class YearFilterChipActionsButtons extends StatelessWidget {
  const YearFilterChipActionsButtons({
    super.key,
    required this.searchCubit,
    required this.currentYear,
    required this.scrollController,
  });

  final SearchCubit searchCubit;
  final int currentYear;
  final FixedExtentScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.black100,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              searchCubit.clearYearFilter();
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.blue100_8,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final year =
                  (currentYear - scrollController.selectedItem).toString();
              searchCubit.selectYear(year);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.blue100_6,
            ),
            child: Text(
              'Apply',
              style: AppStyles.semiBold15(context).copyWith(
                color: context.theme.white100_1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
