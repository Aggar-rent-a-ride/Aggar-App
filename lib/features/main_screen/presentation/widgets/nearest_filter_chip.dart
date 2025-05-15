import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NearestFilterChip extends StatelessWidget {
  const NearestFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      buildWhen: (previous, current) =>
          current is SearchCubitNearestSelected ||
          (previous is SearchCubitNearestSelected &&
              current is! SearchCubitNearestSelected),
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final isNearestSelected = searchCubit.isNearestFilterSelected;

        return FilterChip(
          label: Text(
            "Nearest",
            style: AppStyles.semiBold15(context).copyWith(
              color: isNearestSelected
                  ? context.theme.white100_1
                  : context.theme.blue100_8,
            ),
          ),
          backgroundColor: context.theme.white100_1,
          selectedColor: context.theme.blue100_6,
          checkmarkColor: context.theme.white100_1,
          selected: isNearestSelected,
          onSelected: (selected) {
            searchCubit.toggleNearestFilter();
          },
        );
      },
    );
  }
}
