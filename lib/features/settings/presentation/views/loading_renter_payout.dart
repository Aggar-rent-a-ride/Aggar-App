import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class LoadingRenterPayout extends StatelessWidget {
  const LoadingRenterPayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.grey100_1,
      highlightColor: context.theme.white100_1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: context.theme.white100_1,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          const Gap(25),
          Container(
            width: 200,
            height: 20,
            color: context.theme.white100_1,
          ),
          const Gap(15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.theme.white100_1,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: context.theme.black50.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: context.theme.white100_1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Gap(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 16,
                          color: context.theme.white100_1,
                        ),
                        const Gap(3),
                        Container(
                          width: 60,
                          height: 14,
                          color: context.theme.white100_1,
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      color: context.theme.white100_1,
                    ),
                    Container(
                      width: 80,
                      height: 14,
                      color: context.theme.white100_1,
                    ),
                  ],
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      color: context.theme.white100_1,
                    ),
                    Container(
                      width: 80,
                      height: 14,
                      color: context.theme.white100_1,
                    ),
                  ],
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      color: context.theme.white100_1,
                    ),
                    Container(
                      width: 80,
                      height: 14,
                      color: context.theme.white100_1,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
