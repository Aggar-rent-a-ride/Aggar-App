import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
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
          (previous is SearchCubitTransmissionSelected &&
              current is! SearchCubitTransmissionSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final isTransmissionSelected = searchCubit.isTransmissionFilterSelected;
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
            customShowModelBottmSheet(
              context,
              "Transmission",
              _buildTransmissionSelectionSheet(context),
            );
          },
        );
      },
    );
  }

  Widget _buildTransmissionSelectionSheet(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final List<String> transmissionOptions = ["Manual", "Automatic", "None"];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: transmissionOptions.map((transmission) {
        final isSelected = searchCubit.selectedTransmission == transmission;
        return FilterChip(
          selected: isSelected,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          onSelected: (value) {
            if (value) {
              searchCubit.selectTransmission(transmission);
            } else {
              searchCubit.clearTransmissionFilter();
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
            transmission,
            style: AppStyles.semiBold14(context).copyWith(
              color: isSelected
                  ? context.theme.white100_1
                  : context.theme.blue100_2,
            ),
          ),
        );
      }).toList(),
    );
  }
}
