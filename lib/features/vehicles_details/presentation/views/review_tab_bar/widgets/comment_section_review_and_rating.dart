import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentSectionReviewAndRating extends StatelessWidget {
  const CommentSectionReviewAndRating({
    super.key,
    required this.style,
  });

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCountCubit, ReviewCountState>(
      builder: (context, state) {
        if (state is ReviewVehicleSuccess) {
          return Text(
            "Comments (${state.review})",
            style: style ??
                AppStyles.bold18(context).copyWith(
                  color: context.theme.gray100_3,
                ),
          );
        } else {
          return Text(
            "Comments (0)",
            style: style ??
                AppStyles.bold18(context).copyWith(
                  color: context.theme.gray100_3,
                ),
          );
        }
      },
    );
  }
}
