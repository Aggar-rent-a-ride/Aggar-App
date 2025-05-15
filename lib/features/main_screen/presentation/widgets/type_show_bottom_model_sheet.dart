import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeShowBottomModelSheet extends StatelessWidget {
  const TypeShowBottomModelSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleTypeIds = context.read<VehicleTypeCubit>().vehicleTypeIds;
    final vehicleTypesName = context.read<VehicleTypeCubit>().vehicleTypes;
    final searchCubit = context.read<SearchCubit>();
    return Wrap(
      spacing: 8,
      children: List.generate(
        vehicleTypeIds.length,
        (index) {
          final isSelected = searchCubit.isTypeSelected(vehicleTypeIds[index]);
          return FilterChip(
            selected: isSelected,
            selectedColor: context.theme.blue100_6,
            checkmarkColor: context.theme.white100_1,
            onSelected: (value) {
              if (value) {
                searchCubit.selectType(vehicleTypeIds[index]);
              } else {
                searchCubit.clearTypeFilter();
              }
              Navigator.pop(context);
            },
            backgroundColor: context.theme.white100_1,
            chipAnimationStyle: ChipAnimationStyle(
              enableAnimation: AnimationStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              selectAnimation: AnimationStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
            label: Text(
              vehicleTypesName[vehicleTypeIds.indexOf(vehicleTypeIds[index])],
              style: AppStyles.semiBold14(context).copyWith(
                color: isSelected
                    ? context.theme.white100_1
                    : context.theme.blue100_2,
              ),
            ),
          );
        },
      ),
    );
  }
}
