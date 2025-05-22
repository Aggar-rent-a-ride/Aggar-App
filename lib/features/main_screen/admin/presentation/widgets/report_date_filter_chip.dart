import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_date_in_string.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDateFilterChip extends StatelessWidget {
  const ReportDateFilterChip({
    super.key,
  });

  static const List<String> reportDates = [
    "Today",
    "Yesterday",
    "Last7Days",
    "Last30Days",
    "Last365Days",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        final reportCubit = context.read<FilterCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Report Date:",
                  style: AppStyles.semiBold16(context)
                      .copyWith(color: context.theme.blue100_1),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: List.generate(
                reportDates.length,
                (index) {
                  final date = reportDates[index];
                  final isSelected = reportCubit.isDateSelected(date);
                  return FilterChip(
                    selected: isSelected,
                    selectedColor: context.theme.blue100_6,
                    checkmarkColor: context.theme.white100_1,
                    onSelected: (value) async {
                      if (value) {
                        reportCubit.selectDate(date);
                      } else {
                        reportCubit.clearDateFilter();
                      }
                    },
                    backgroundColor: context.theme.white100_1,
                    chipAnimationStyle: ChipAnimationStyle(
                      enableAnimation: AnimationStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      selectAnimation: AnimationStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),
                    label: Text(
                      getDateInString(date),
                      style: AppStyles.semiBold14(context).copyWith(
                        color: isSelected
                            ? context.theme.white100_1
                            : context.theme.blue100_2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
