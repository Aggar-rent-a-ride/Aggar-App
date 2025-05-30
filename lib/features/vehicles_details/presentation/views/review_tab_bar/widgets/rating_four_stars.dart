import 'package:flutter/material.dart';

class RatingFourStars extends StatelessWidget {
  const RatingFourStars({
    super.key,
    this.rating,
    required this.color,
  });

  final double? rating;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: List.generate(
        5,
        (index) {
          if (index < rating!.floor()) {
            return Icon(
              Icons.star,
              color: color,
              size: 12,
            );
          } else if (index < rating! && rating! - index < 1) {
            return Icon(
              Icons.star_half,
              color: color,
              size: 12,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: color,
              size: 12,
            );
          }
        },
      ),
    );
  }
}
