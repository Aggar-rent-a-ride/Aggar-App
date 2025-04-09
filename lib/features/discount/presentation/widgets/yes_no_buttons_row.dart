import 'package:aggar/core/widgets/custom_elevation_button.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class YesNoButtonsRow extends StatelessWidget {
  const YesNoButtonsRow({super.key, required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountCubit, DiscountState>(
      builder: (context, state) {
        return Row(
          children: [
            CustomElevationButton(
              title: "Yes",
              paddingHorizental: 40,
              paddingVertical: 15,
              isSelected: isSelected,
              onPressed: () {},
            ),
            const Gap(10),
            CustomElevationButton(
              title: "No",
              paddingHorizental: 40,
              paddingVertical: 15,
              isSelected: isSelected,
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
