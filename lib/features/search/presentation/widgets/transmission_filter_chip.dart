import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/search/presentation/widgets/transmission_show_bottom_model_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransmissionFilterChip extends StatelessWidget {
  const TransmissionFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitTransmissionSelected ||
          current is SearchCubitStatusSelected ||
          current is SearchCubitFiltersReset ||
          (previous is SearchCubitTransmissionSelected &&
              current is! SearchCubitTransmissionSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final bool isTransmissionSelected = searchCubit.isStatusFilterSelected
            ? false
            : searchCubit.isTransmissionFilterSelected;
        final selectedTransmission = searchCubit.selectedTransmission;
        return FilterChip(
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isTransmissionSelected,
          labelPadding: const EdgeInsets.all(0),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedTransmission ?? "Transmission",
                style: AppStyles.semiBold15(context).copyWith(
                  color: isTransmissionSelected
                      ? context.theme.white100_1
                      : context.theme.blue100_8,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: isTransmissionSelected
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
              "Transmission",
              const TransmissionShowBottomModelSheet(),
            );
          },
        );
      },
    );
  }
}
