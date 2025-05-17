import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_price.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/search/presentation/widgets/pricing_show_model_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PricingFilterChip extends StatelessWidget {
  const PricingFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitPriceRangeSelected ||
          current is SearchCubitStatusSelected ||
          current is SearchCubitFiltersReset ||
          (previous is SearchCubitPriceRangeSelected &&
              current is! SearchCubitPriceRangeSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final bool isPriceSelected = searchCubit.isStatusFilterSelected
            ? false
            : searchCubit.isPriceFilterSelected;
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
                getPriceLabel(minPrice, maxPrice),
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
            if (searchCubit.isStatusFilterSelected) {
              searchCubit.clearStatusFilter();
            }
            customShowModelBottmSheet(
              context,
              "Price Range",
              const PricingShowModelBottomSheet(),
            );
          },
        );
      },
    );
  }
}
