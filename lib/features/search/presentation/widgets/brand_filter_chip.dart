import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/search/presentation/widgets/brand_show_model_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandFilterChip extends StatelessWidget {
  const BrandFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitBrandSelected ||
          current is SearchCubitStatusSelected ||
          current is SearchCubitFiltersReset ||
          (previous is SearchCubitBrandSelected &&
              current is! SearchCubitBrandSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final vehilceBrandCubit = context.read<VehicleBrandCubit>();
        final bool isBrandSelected = searchCubit.isStatusFilterSelected
            ? false
            : searchCubit.isBrandFilterSelected;
        final selectedBrand = searchCubit.selectedBrand;
        final vehicleBrands = vehilceBrandCubit.vehicleBrands;
        final vehicleBrandIds = vehilceBrandCubit.vehicleBrandIds;
        return FilterChip(
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isBrandSelected,
          labelPadding: const EdgeInsets.all(0),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedBrand == null
                    ? "Brand"
                    : vehicleBrands[vehicleBrandIds.indexOf(selectedBrand)],
                style: AppStyles.semiBold15(context).copyWith(
                  color: isBrandSelected
                      ? context.theme.white100_1
                      : context.theme.blue100_8,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: isBrandSelected
                    ? context.theme.white100_1
                    : context.theme.blue100_8,
              )
            ],
          ),
          onSelected: (bool selected) {
            if (searchCubit.isStatusFilterSelected) {
              searchCubit.clearStatusFilter();
            }
            customShowModelBottmSheet(
              context,
              "Brand",
              const BrandShowModelBottomSheet(),
            );
          },
        );
      },
    );
  }
}
