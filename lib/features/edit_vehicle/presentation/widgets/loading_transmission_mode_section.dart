import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingTransmissionModeSection extends StatelessWidget {
  const LoadingTransmissionModeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: 180,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Gap(20),
        Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25,
              width: 180,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 25,
              width: 180,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 25,
              width: 180,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        )
      ],
    );
  }
}
