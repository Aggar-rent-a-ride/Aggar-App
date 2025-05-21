import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingUserStatisticsCard extends StatelessWidget {
  const LoadingUserStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.gray100_1,
      highlightColor: context.theme.white100_1,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        decoration: BoxDecoration(
          color: context.theme.white100_1,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
    );
  }
}
