import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PricingFilterChip extends StatelessWidget {
  const PricingFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitPriceRangeSelected ||
          (previous is SearchCubitPriceRangeSelected &&
              current is! SearchCubitPriceRangeSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final isPriceSelected = searchCubit.isPriceFilterSelected;
        final minPrice = searchCubit.minPrice;
        final maxPrice = searchCubit.maxPrice;
        final isFilterVisible = searchCubit.isFilterVisible;

        if (!isFilterVisible) return const SizedBox.shrink();

        return FilterChip(
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isPriceSelected,
          labelPadding: const EdgeInsets.all(0),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getPriceLabel(minPrice, maxPrice),
                style: AppStyles.semiBold15(context).copyWith(
                  color: isPriceSelected
                      ? context.theme.white100_1
                      : context.theme.blue100_8,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: isPriceSelected
                    ? context.theme.white100_1
                    : context.theme.blue100_8,
              ),
            ],
          ),
          onSelected: (bool selected) {
            customShowModelBottmSheet(
              context,
              "Price Range",
              buildPriceSelectionSheet(context),
            );
          },
        );
      },
    );
  }

  String _getPriceLabel(double? minPrice, double? maxPrice) {
    if (minPrice == null && maxPrice == null) {
      return "Pricing";
    }
    if (minPrice != null && maxPrice != null) {
      return "\$${minPrice.round()} - \$${maxPrice.round()}";
    }
    if (minPrice != null) {
      return "From \$${minPrice.round()}";
    }
    return "Up to \$${maxPrice!.round()}";
  }

  Widget buildPriceSelectionSheet(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final minPrice = searchCubit.minPrice ?? 0.0;
    final maxPrice = searchCubit.maxPrice ?? 10000.0;

    return StatefulBuilder(
      builder: (context, setState) {
        double tempMinPrice = minPrice;
        double tempMaxPrice = maxPrice;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(10),
            RangeSlider(
              values: RangeValues(tempMinPrice, tempMaxPrice),
              min: 0,
              max: 10000,
              divisions: 200,
              labels: RangeLabels(
                "\$${tempMinPrice.round()}",
                "\$${tempMaxPrice.round()}",
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  tempMinPrice = values.start;
                  tempMaxPrice = values.end;
                });
              },
              activeColor: context.theme.blue100_6,
              inactiveColor: context.theme.gray100_1,
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${tempMinPrice.round()}",
                  style: AppStyles.medium16(context).copyWith(
                    color: context.theme.blue100_8,
                  ),
                ),
                Text(
                  "\$${tempMaxPrice.round()}",
                  style: AppStyles.medium16(context).copyWith(
                    color: context.theme.blue100_8,
                  ),
                ),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: AppStyles.medium16(context).copyWith(
                      color: context.theme.gray100_1,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    searchCubit.setPriceRange(
                      tempMinPrice == 0.0 && tempMaxPrice == 10000.0
                          ? null
                          : tempMinPrice,
                      tempMinPrice == 0.0 && tempMaxPrice == 10000.0
                          ? null
                          : tempMaxPrice,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.blue100_6,
                    foregroundColor: context.theme.white100_1,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    "Apply",
                    style: AppStyles.semiBold16(context).copyWith(
                      color: context.theme.white100_1,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
          ],
        );
      },
    );
  }
}
