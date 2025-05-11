import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PricingFilterChip extends StatefulWidget {
  const PricingFilterChip({
    super.key,
  });

  @override
  State<PricingFilterChip> createState() => _PricingFilterChipState();
}

class _PricingFilterChipState extends State<PricingFilterChip> {
  bool isPriceSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      backgroundColor: context.theme.white100_1,
      selectedColor: context.theme.blue100_6,
      checkmarkColor: context.theme.white100_1,
      selected: isPriceSelected,
      labelPadding: const EdgeInsets.all(0),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(
            "Pricing",
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
          )
        ],
      ),
      onSelected: (bool selected) {
        setState(() {
          isPriceSelected = selected;
        });
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const SizedBox();
          },
        );
      },
    );
  }
}
