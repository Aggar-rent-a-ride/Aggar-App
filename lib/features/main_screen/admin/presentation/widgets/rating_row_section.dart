import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class RatingRowSection extends StatelessWidget {
  const RatingRowSection({
    super.key,
    required this.behavior,
    required this.punctuality,
    required this.careOrtruthfulness,
  });

  final int behavior;
  final int punctuality;
  final int careOrtruthfulness;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Behavior",
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < behavior ? Icons.star : Icons.star_border,
                  color: index < behavior ? Colors.amber : Colors.grey,
                  size: MediaQuery.sizeOf(context).width * 0.04,
                );
              }),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Punctuality",
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < punctuality ? Icons.star : Icons.star_border,
                  color: index < punctuality ? Colors.amber : Colors.grey,
                  size: MediaQuery.sizeOf(context).width * 0.04,
                );
              }),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Care",
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < careOrtruthfulness ? Icons.star : Icons.star_border,
                  color:
                      index < careOrtruthfulness ? Colors.amber : Colors.grey,
                  size: MediaQuery.sizeOf(context).width * 0.04,
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
