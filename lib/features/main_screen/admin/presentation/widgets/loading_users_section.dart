import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class LoadingUsersSection extends StatelessWidget {
  const LoadingUsersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Shimmer.fromColors(
          baseColor: context.theme.grey100_1,
          highlightColor: context.theme.white100_1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
              const Gap(10),
              Column(
                spacing: 15,
                children: List.generate(
                  3,
                  (index) => Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: context.theme.white100_1,
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        decoration: BoxDecoration(
                          color: context.theme.white100_1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
            ],
          )),
    );
  }
}
