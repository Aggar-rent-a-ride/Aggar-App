import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class RateNumberSectionWithStars extends StatelessWidget {
  const RateNumberSectionWithStars({
    super.key,
    required this.rate,
    required this.color,
    required this.containerColor,
  });

  final double rate;
  final Color color;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 12,
            color: color,
          ),
          Text(
            rate.toStringAsFixed(1),
            style: AppStyles.medium14(context).copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
