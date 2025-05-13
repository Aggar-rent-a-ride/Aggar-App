import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
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
          (previous is SearchCubitRatingSelected &&
              current is! SearchCubitRatingSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final isRatingSelected = searchCubit.isRateFilterSelected;
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
                    ? "${selectedRating.toStringAsFixed(0)} Stars"
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
            customShowModelBottmSheet(
              context,
              "Rating",
              buildRatingSelectionSheet(context),
            );
          },
        );
      },
    );
  }

  Widget buildRatingSelectionSheet(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final currentRating = searchCubit.selectedRate ?? 0.0;

    return StatefulBuilder(
      builder: (context, setState) {
        double tempRating = currentRating;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = (index + 1).toDouble();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tempRating = starValue;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        starValue <= tempRating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: context.theme.blue100_8,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      searchCubit.clearRateFilter();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Clear",
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.blue100_8,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.blue100_6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      searchCubit.selectRate(tempRating);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Apply",
                      style: AppStyles.semiBold16(context).copyWith(
                        color: context.theme.white100_1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
