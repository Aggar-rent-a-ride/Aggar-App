import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_graph_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RatingAndReviewsSection extends StatelessWidget {
  const RatingAndReviewsSection({super.key, this.style});
  final TextStyle? style;

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
                const RatingGraphSection(),
                const Gap(10),
                Column(
                  spacing: 10,
                  children: List.generate(
                    state.review!.data.length,
                    (index) {
                      String dateTime = state.review!.data[index].createdAt;
                      return CommentSection(
                        name: state.review!.data[index].reviewer.name,
                        date: dateTime.split('T')[0],
                        commentText: state.review!.data[index].comments,
                        rate: state.review!.data[index].rate,
                        imageUrl: AppAssets.assetsIconsAddPhoto,
                      );
                    },
                  ),
                ),
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
