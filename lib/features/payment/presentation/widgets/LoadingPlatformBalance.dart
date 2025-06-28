import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: context.theme.gray100_2.withOpacity(0.3),
        highlightColor: context.theme.white100_1.withOpacity(0.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const Gap(10),
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.17,
              decoration: BoxDecoration(
                color: context.theme.white100_2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Gap(20),
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const Gap(10),
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.1,
              decoration: BoxDecoration(
                color: context.theme.white100_2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Gap(10),
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.1,
              decoration: BoxDecoration(
                color: context.theme.white100_2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Gap(10),
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.1,
              decoration: BoxDecoration(
                color: context.theme.white100_2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
