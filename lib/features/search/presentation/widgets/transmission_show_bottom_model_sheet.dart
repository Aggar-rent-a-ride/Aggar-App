import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransmissionShowBottomModelSheet extends StatelessWidget {
  const TransmissionShowBottomModelSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
