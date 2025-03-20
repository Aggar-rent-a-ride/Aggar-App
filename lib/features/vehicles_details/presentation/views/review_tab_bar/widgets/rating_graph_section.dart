import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_number_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/themes/app_colors.dart';

class RatingGraphSection extends StatelessWidget {
  const RatingGraphSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const RatingNumberSection(
          rating: 4,
          totalRaring: "5,582,445",
        ),
        const Gap(25),
        Expanded(
          child: Text(
            "Rating and reviews are verified and are from people who rent the same type of vehicle that you rent  ",
            style: AppStyles.medium15(context).copyWith(
              color: AppLightColors.myBlack50,
            ),
          ),
        ),
      ],
    );
  }
}
