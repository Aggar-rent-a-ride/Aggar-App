import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BrandFilterChip extends StatefulWidget {
  const BrandFilterChip({
    super.key,
  });

  @override
  State<BrandFilterChip> createState() => _BrandFilterChipState();
}

class _BrandFilterChipState extends State<BrandFilterChip> {
  bool isBrandSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      backgroundColor: context.theme.white100_1,
      selectedColor: context.theme.blue100_6,
      checkmarkColor: context.theme.white100_1,
      selected: isBrandSelected,
      labelPadding: const EdgeInsets.all(0),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(
            "Brand",
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
        setState(() {
          isBrandSelected = selected;
        });
        showModalBottomSheet(
          backgroundColor: context.theme.white100_1,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
          sheetAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            reverseDuration: const Duration(milliseconds: 300),
            reverseCurve: Curves.ease,
          ),
          context: context,
          builder: (context) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(10),
                  const Text("Brand"),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      context.read<VehicleBrandCubit>().vehicleBrands.length,
                      (index) {
                        return Chip(
                          label: Text(context
                              .read<VehicleBrandCubit>()
                              .vehicleBrands[index]),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
