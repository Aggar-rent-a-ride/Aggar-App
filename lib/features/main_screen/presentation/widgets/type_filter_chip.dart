import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/presentation/widgets/type_show_bottom_model_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeFilterChip extends StatelessWidget {
  const TypeFilterChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitTypeSelected ||
          (previous is SearchCubitTypeSelected &&
              current is! SearchCubitTypeSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final vehicleTypeCubit = context.read<VehicleTypeCubit>();
        final isTypeSelected = searchCubit.isTypeFilterSelected;
        final selectedType = searchCubit.selectedType;
        final vehicleTypes = vehicleTypeCubit.vehicleTypes;
        final vehicleTypesIds = vehicleTypeCubit.vehicleTypeIds;
        return FilterChip(
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isTypeSelected,
          labelPadding: const EdgeInsets.all(0),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedType == null
                    ? "Type"
                    : vehicleTypes[vehicleTypesIds.indexOf(selectedType)],
                style: AppStyles.semiBold15(context).copyWith(
                  color: isTypeSelected
                      ? context.theme.white100_1
                      : context.theme.blue100_8,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: isTypeSelected
                    ? context.theme.white100_1
                    : context.theme.blue100_8,
              )
            ],
          ),
          onSelected: (bool selected) {
            customShowModelBottmSheet(
              context,
              "Type",
              const TypeShowBottomModelSheet(),
            );
          },
        );
      },
    );
  }
}
