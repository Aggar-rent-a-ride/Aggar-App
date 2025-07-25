import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/apply_filter_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/clear_filter_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_date_filter_chip.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_sorting_direction_filter_chip.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_filter_chip.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.accessToken,
  });
  final String accessToken;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 0),
            blurRadius: 3,
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          overlayColor: context.theme.blue100_2,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: () async {
          await customShowModelBottmSheet(
            context,
            "Filter Reports",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: const Divider(),
                ),
                const Gap(5),
                const ReportStatusFilterChip(),
                const Gap(20),
                const ReportTypeFilterChip(),
                const Gap(20),
                const ReportDateFilterChip(),
                const Gap(20),
                const ReportSortingDirectionFilterChip(),
                const Gap(20),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: ClearFilterButton(
                          filterCubit: context.read<FilterCubit>(),
                          accessToken: accessToken),
                    ),
                    Expanded(
                      child: ApplyFilterButton(
                          accessToken: accessToken,
                          filterCubit: context.read<FilterCubit>()),
                    ),
                  ],
                ),
                const Gap(30),
              ],
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              color: context.theme.black25,
              size: 18,
            ),
            Container(
              height: 12,
              width: 1.2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: context.theme.black25,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Filter",
              style: AppStyles.bold12(context).copyWith(
                color: context.theme.black25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
