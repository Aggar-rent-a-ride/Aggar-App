import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/year_show_bottom_model_sheet.dart';
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
              const YearShowBottomModelSheet(),
            );
          },
        );
      },
    );
  }
}
