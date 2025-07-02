import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAllReportSection extends StatelessWidget {
  const LoadingAllReportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: context.theme.grey100_1,
        highlightColor: context.theme.white100_1,
        child: Column(
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
            Column(
              spacing: 15,
              children: List.generate(
                3,
                (index) => Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ));
  }
}
