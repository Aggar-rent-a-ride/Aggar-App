import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyFilterButton extends StatelessWidget {
  const ApplyFilterButton({
    super.key,
    required this.accessToken,
    required this.filterCubit,
  });

  final String accessToken;
  final FilterCubit filterCubit;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.blue100_6,
        foregroundColor: context.theme.white100_1,
        overlayColor: context.theme.white100_1.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
        shadowColor: context.theme.blue100_6.withOpacity(0.3),
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<ReportCubit>().refreshReports(
              accessToken,
              filterCubit.selectedType,
              filterCubit.selectedStatus,
              filterCubit.selectedDate,
              filterCubit.selectedSortingDirection,
            );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            size: 18,
            color: context.theme.white100_1,
          ),
          const SizedBox(width: 8),
          Text(
            'Apply Filters',
            style: AppStyles.semiBold14(context).copyWith(
              color: context.theme.white100_1,
            ),
          ),
        ],
      ),
    );
  }
}
