import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleReviewList extends StatelessWidget {
  const VehicleReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewSuccess) {
          if (state.review!.data.isEmpty) {
            return Center(
              child: Text(
                'No comments yet',
                style: AppStyles.bold15(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: List.generate(
                  state.review!.data.length > 2 ? 2 : state.review!.data.length,
                  (index) => CommentSection(
                    imageUrl:
                        state.review!.data[index].reviewer.imagePath ?? "",
                    name: state.review!.data[index].reviewer.name,
                    commentText: state.review!.data[index].comments,
                    date: state.review!.data[index].createdAt,
                    rate: state.review!.data[index].rate,
                    id: state.review!.data[index].id,
                    typeOfReport: "CustomerReview",
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
