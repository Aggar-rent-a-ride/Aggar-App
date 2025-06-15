import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_four_stars.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class RatingNumberSection extends StatelessWidget {
  const RatingNumberSection({super.key, this.rating});
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rating != null
                ? rating!.toStringAsFixed(rating! % 1 == 0 ? 0 : 1)
                : '',
            style: AppStyles.medium65(context).copyWith(
              color: context.theme.black100,
            ),
          ),
          RatingFourStars(
            rating: rating,
            color: context.theme.blue100_2,
          ),
        ],
      ),
    );
  }
}
