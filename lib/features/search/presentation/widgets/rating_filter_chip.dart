import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/search/presentation/widgets/rating_show_bottom_model_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingFilterChip extends StatelessWidget {
  const RatingFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitRatingSelected ||
          current is SearchCubitStatusSelected ||
          current is SearchCubitFiltersReset ||
          (previous is SearchCubitRatingSelected &&
              current is! SearchCubitRatingSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final bool isRatingSelected = searchCubit.isStatusFilterSelected
            ? false
            : searchCubit.isRateFilterSelected;
        final selectedRating = searchCubit.selectedRate;

        return FilterChip(
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isRatingSelected,
          labelPadding: const EdgeInsets.all(0),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedRating != null
                    ? "${selectedRating.toString()} Stars"
                    : "Rating",
                style: AppStyles.semiBold15(context).copyWith(
                  color: isRatingSelected
                      ? context.theme.white100_1
                      : context.theme.blue100_8,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: isRatingSelected
                    ? context.theme.white100_1
                    : context.theme.blue100_8,
              ),
            ],
          ),
          onSelected: (bool selected) {
            if (searchCubit.isStatusFilterSelected) {
              searchCubit.clearStatusFilter();
            }
            customShowModelBottmSheet(
              context,
              "Rating",
              const RatingShowBottomModelSheet(),
            );
          },
        );
      },
    );
  }
}
