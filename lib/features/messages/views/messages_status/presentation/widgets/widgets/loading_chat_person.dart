import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingChatPerson extends StatelessWidget {
  const LoadingChatPerson({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const Gap(8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Gap(8),
            Container(
              height: 20,
              width: 180,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 20,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Gap(8),
            Container(
              height: 20,
              width: 40,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
