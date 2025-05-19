import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportStatusFilterChip extends StatelessWidget {
  const ReportStatusFilterChip({
    super.key,
  });
  static const List<String> reportStatuses = [
    "Pending",
    "Reviewed",
    "Rejected"
  ];

  @override
  Widget build(BuildContext context) {
    final reportCubit = context.read<FilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Report Status :",
          style: AppStyles.semiBold16(context)
              .copyWith(color: context.theme.blue100_1),
        ),
        Wrap(
          spacing: 8,
          children: List.generate(
            reportStatuses.length,
            (index) {
              final status = reportStatuses[index];
              final isSelected = reportCubit.isStatusSelected(status);
              return FilterChip(
                selected: isSelected,
                selectedColor: context.theme.blue100_6,
                checkmarkColor: context.theme.white100_1,
                onSelected: (value) {
                  if (value) {
                    reportCubit.selectStatus(status);
                  } else {
                    reportCubit.clearStatusFilter();
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
                  status,
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
