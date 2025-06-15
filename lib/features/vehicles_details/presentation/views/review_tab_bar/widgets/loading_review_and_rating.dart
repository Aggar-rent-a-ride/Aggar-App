import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingReviewAndRating extends StatelessWidget {
  const LoadingReviewAndRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35,
                width: MediaQuery.sizeOf(context).width * 0.4,
                decoration: BoxDecoration(
                  color: context.theme.white100_1,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).width * 0.15,
                    width: MediaQuery.sizeOf(context).width * 0.15,
                    decoration: BoxDecoration(
                      color: context.theme.white100_1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).width * 0.15,
                    width: MediaQuery.sizeOf(context).width * 0.65,
                    decoration: BoxDecoration(
                      color: context.theme.white100_1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              Container(
                height: 35,
                width: MediaQuery.sizeOf(context).width * 0.4,
                decoration: BoxDecoration(
                  color: context.theme.white100_1,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).width * 0.2,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: context.theme.white100_1,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ));
  }
}
