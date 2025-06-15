import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_number_section.dart';
import 'package:flutter/material.dart';

class RatingGraphSection extends StatelessWidget {
  const RatingGraphSection({super.key, this.vehicleRate});
  final double? vehicleRate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        vehicleRate == null
            ? const SizedBox()
            : RatingNumberSection(
                rating: vehicleRate,
              ),
        Expanded(
          child: Text(
            "Rating and reviews are verified and are from people who rent the same type of vehicle that you rent  ",
            style: AppStyles.medium15(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ),
      ],
    );
  }
}
