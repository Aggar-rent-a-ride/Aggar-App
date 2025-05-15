import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusShowBottomModelSheet extends StatelessWidget {
  const StatusShowBottomModelSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final List<String> statusOptions = ["Active", "OutOfService"];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: statusOptions.map((status) {
        final isSelected = searchCubit.selectedStatus == status;
        return FilterChip(
          selected: isSelected,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          onSelected: (value) {
            if (value) {
              searchCubit.selectStatus(status);
            } else {
              searchCubit.clearStatusFilter();
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
            status,
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
