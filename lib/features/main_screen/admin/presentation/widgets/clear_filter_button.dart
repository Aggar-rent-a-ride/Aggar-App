import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearFilterButton extends StatelessWidget {
  const ClearFilterButton({
    super.key,
    required this.filterCubit,
    required this.accessToken,
  });

  final FilterCubit filterCubit;
  final String accessToken;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: context.theme.blue100_6,
          width: 1.5,
        ),
        backgroundColor: context.theme.white100_1,
        foregroundColor: context.theme.blue100_6,
        overlayColor: context.theme.blue100_6.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      onPressed: () {
        filterCubit.resetFilters();
        Navigator.pop(context);
        context.read<ReportCubit>().refreshReports(
              accessToken,
              null,
              null,
              null,
              null,
            );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.clear_all,
            size: 18,
            color: context.theme.blue100_6,
          ),
          const SizedBox(width: 8),
          Text(
            'Clear All',
            style: AppStyles.semiBold14(context).copyWith(
              color: context.theme.blue100_6,
            ),
          ),
        ],
      ),
    );
  }
}
