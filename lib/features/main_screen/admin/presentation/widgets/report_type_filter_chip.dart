import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportTypeFilterChip extends StatelessWidget {
  const ReportTypeFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        final reportCubit = context.read<FilterCubit>();
        return Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Report Type:",
                  style: AppStyles.semiBold16(context)
                      .copyWith(color: context.theme.blue100_1),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                reportCubit.reportTypes.length,
                (index) {
                  final type = reportCubit.reportTypes[index];
                  final isSelected = reportCubit.isTypeSelected(type);
                  return FilterChip(
                    selected: isSelected,
                    selectedColor: context.theme.blue100_6,
                    checkmarkColor: context.theme.white100_1,
                    onSelected: (value) {
                      if (value) {
                        reportCubit.selectType(type);
                      } else {
                        reportCubit.clearTypeFilter();
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
                      type,
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
