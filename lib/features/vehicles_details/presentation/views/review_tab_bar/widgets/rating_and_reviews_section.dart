import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/comment_section_review_and_rating.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_graph_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RatingAndReviewsSection extends StatelessWidget {
  const RatingAndReviewsSection({super.key, this.style, this.vehicleRate});
  final TextStyle? style;
  final double? vehicleRate;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewVehicleSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rating and Reviews",
                  style: style ??
                      AppStyles.bold18(context).copyWith(
                        color: context.theme.gray100_3,
                      ),
                ),
                RatingGraphSection(
                  vehicleRate: vehicleRate,
                ),
                const Gap(15),
                CommentSectionReviewAndRating(style: style),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
