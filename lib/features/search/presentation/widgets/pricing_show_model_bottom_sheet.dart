import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/filter_apply_with_clear_buttons.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PricingShowModelBottomSheet extends StatefulWidget {
  const PricingShowModelBottomSheet({super.key});

  @override
  State<PricingShowModelBottomSheet> createState() =>
      _PricingShowModelBottomSheetState();
}

class _PricingShowModelBottomSheetState
    extends State<PricingShowModelBottomSheet> {
  late double tempMinPrice;
  late double tempMaxPrice;

  @override
  void initState() {
    super.initState();
    final searchCubit = context.read<SearchCubit>();
    tempMinPrice = searchCubit.minPrice ?? 0.0;
    tempMaxPrice = searchCubit.maxPrice ?? 5000.0;
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(10),
        RangeSlider(
          values: RangeValues(tempMinPrice, tempMaxPrice),
          min: 0,
          max: 5000,
          divisions: 10,
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
        FilterApplyWithClearButtons(
          onPressedApply: () {
            searchCubit.setPriceRange(
              tempMinPrice == 0.0 && tempMaxPrice == 5000.0
                  ? null
                  : tempMinPrice,
              tempMinPrice == 0.0 && tempMaxPrice == 5000.0
                  ? null
                  : tempMaxPrice,
            );
            Navigator.pop(context);
          },
          onPressedClear: () {
            searchCubit.clearPricingFilter();
            Navigator.pop(context);
          },
        ),
        const Gap(20),
      ],
    );
  }
}
