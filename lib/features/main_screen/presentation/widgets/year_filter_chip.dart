import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/year_filter_chip_actions_buttons.dart';
import 'package:aggar/features/main_screen/presentation/widgets/year_filter_chip_center_lines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YearFilterChip extends StatelessWidget {
  const YearFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitYearSelected ||
          (previous is SearchCubitYearSelected &&
              current is! SearchCubitYearSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final isYearSelected = searchCubit.isYearFilterSelected;
        final selectedYear = searchCubit.selectedYear;
        return FilterChip(
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isYearSelected,
          labelPadding: const EdgeInsets.all(0),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedYear ?? "Year",
                style: AppStyles.semiBold15(context).copyWith(
                  color: isYearSelected
                      ? context.theme.white100_1
                      : context.theme.blue100_8,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: isYearSelected
                    ? context.theme.white100_1
                    : context.theme.blue100_8,
              )
            ],
          ),
          onSelected: (bool selected) {
            customShowModelBottmSheet(
              context,
              "Year",
              buildYearSelectionSheet(context),
            );
          },
        );
      },
    );
  }

  Widget buildYearSelectionSheet(BuildContext context) {
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
        YearFilterChipActionsButtons(
            searchCubit: searchCubit,
            currentYear: currentYear,
            scrollController: scrollController),
      ],
    );
  }
}
