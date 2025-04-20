import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/edit_vehicle/presentation/widgets/loading_field.dart';
import 'package:flutter/material.dart';

class LoadingSeatsNoWithOverviewFields extends StatelessWidget {
  const LoadingSeatsNoWithOverviewFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Container(
          height: 25,
          width: 140,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Row(
          spacing: 15,
          children: [
            LoadingField(),
            LoadingField(),
          ],
        ),
        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 80,
              color: context.theme.white100_1,
            ),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
