import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTypeBrandScreen extends StatelessWidget {
  const LoadingTypeBrandScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.gray100_1,
      highlightColor: context.theme.white100_1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) => Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
