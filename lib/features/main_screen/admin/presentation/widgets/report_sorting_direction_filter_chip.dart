import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportSortingDirectionFilterChip extends StatelessWidget {
  const ReportSortingDirectionFilterChip({
    super.key,
  });

  static const List<String> sortingDirections = [
    "Ascending",
    "Descending",
  ];

  @override
  Widget build(BuildContext context) {
    final reportCubit = context.read<FilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sorting Direction :",
          style: AppStyles.semiBold16(context)
              .copyWith(color: context.theme.blue100_1),
        ),
        Wrap(
          spacing: 8,
          children: List.generate(
            sortingDirections.length,
            (index) {
              final direction = sortingDirections[index];
              final isSelected =
                  reportCubit.isSortingDirectionSelected(direction);
              return FilterChip(
                selected: isSelected,
                selectedColor: context.theme.blue100_6,
                checkmarkColor: context.theme.white100_1,
                onSelected: (value) {
                  if (value) {
                    reportCubit.selectSortingDirection(direction);
                  } else {
                    reportCubit.clearSortingDirectionFilter();
                  }
                  Navigator.pop(context);
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
                  direction,
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
  }
}
