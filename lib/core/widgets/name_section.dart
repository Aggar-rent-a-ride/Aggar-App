import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_four_stars.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NameSection extends StatelessWidget {
  const NameSection({
    super.key,
    required this.date,
    required this.name,
    this.rating,
  });
  final String date;
  final String name;
  final double? rating;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppStyles.bold18(context).copyWith(
            color: AppLightColors.myBlue100_2,
          ),
        ),
        Row(
          children: [
            RatingFourStars(
              rating: rating,
              color: AppLightColors.myYellow100_1,
            ),
            const Gap(5),
            Text(
              date,
              style: AppStyles.medium10(context).copyWith(
                color: AppLightColors.myBlack50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
