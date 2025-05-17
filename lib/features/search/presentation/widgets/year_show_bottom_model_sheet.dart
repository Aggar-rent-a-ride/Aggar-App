import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/filter_apply_with_clear_buttons.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/widgets/year_filter_chip_center_lines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class YearShowBottomModelSheet extends StatelessWidget {
  const YearShowBottomModelSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final currentYear = DateTime.now().year;
    const startYear = 1900;
    final selectedYear = searchCubit.selectedYear ?? currentYear.toString();
    final initialIndex = currentYear - int.parse(selectedYear);
    final scrollController =
        FixedExtentScrollController(initialItem: initialIndex);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
              child: ListWheelScrollView.useDelegate(
                controller: scrollController,
                physics: const FixedExtentScrollPhysics(),
                itemExtent: 40,
                perspective: 0.005,
                diameterRatio: 1.5,
                squeeze: 0.9,
                onSelectedItemChanged: (index) {},
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: currentYear - startYear + 1,
                  builder: (context, index) {
                    final year = (currentYear - index).toString();
                    return Center(
                      child: Text(
                        year,
                        style: index == scrollController.initialItem
                            ? AppStyles.bold20(context).copyWith(
                                color: context.theme.blue100_8,
                              )
                            : AppStyles.medium16(context).copyWith(
                                color: context.theme.black100.withOpacity(0.7),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const YearFilterChipCenterLines(),
          ],
        ),
        FilterApplyWithClearButtons(
          onPressedApply: () {
            final year =
                (currentYear - scrollController.selectedItem).toString();
            searchCubit.selectYear(year);
            Navigator.pop(context);
          },
          onPressedClear: () {
            searchCubit.clearYearFilter();
            Navigator.pop(context);
          },
        ),
        const Gap(20),
      ],
    );
  }
}
