import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/filter_apply_with_clear_buttons.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RatingShowBottomModelSheet extends StatefulWidget {
  const RatingShowBottomModelSheet({super.key});

  @override
  State<RatingShowBottomModelSheet> createState() =>
      _RatingShowBottomModelSheetState();
}

class _RatingShowBottomModelSheetState
    extends State<RatingShowBottomModelSheet> {
  late double tempRating;

  @override
  void initState() {
    super.initState();
    final searchCubit = context.read<SearchCubit>();
    tempRating = searchCubit.selectedRate ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starPosition = index + 1;
            return Stack(
              children: [
                Icon(
                  Icons.star_border_rounded,
                  color: context.theme.blue100_8,
                  size: 40,
                ),
                if (tempRating >= starPosition)
                  Icon(
                    Icons.star_rounded,
                    color: context.theme.blue100_8,
                    size: 40,
                  )
                else if (tempRating > index && tempRating < starPosition)
                  Icon(
                    Icons.star_half_rounded,
                    color: context.theme.blue100_8,
                    size: 40,
                  ),
                Positioned.fill(
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tempRating = index + 0.5;
                      });
                    },
                  ),
                ),
                Positioned.fill(
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tempRating = starPosition.toDouble();
                      });
                    },
                  ),
                ),
              ],
            );
          }),
        ),
        const Gap(10),
        FilterApplyWithClearButtons(
          onPressedApply: () {
            searchCubit.selectRate(tempRating);
            Navigator.pop(context);
          },
          onPressedClear: () {
            searchCubit.clearRateFilter();
            Navigator.pop(context);
          },
        ),
        const Gap(20),
      ],
    );
  }
}
