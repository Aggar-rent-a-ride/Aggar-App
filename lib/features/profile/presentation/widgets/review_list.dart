import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/profile/presentation/views/review_user_screen.dart';
import 'package:aggar/features/profile/presentation/widgets/comments_count.dart';
import 'package:aggar/features/profile/presentation/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/cubit/user_review_cubit/user_review_cubit.dart';
import '../../../../core/cubit/user_review_cubit/user_review_state.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserReviewCubit, UserReviewState>(
      builder: (context, state) {
        if (state is UserReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserReviewSuccess) {
          if (state.review!.data.isEmpty) {
            return Center(
              child: Text(
                'No reviews available',
                style: AppStyles.medium14(
                  context,
                ).copyWith(color: context.theme.black50),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 15,
            children: [
              const Gap(15),
              const CommentsCount(),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.review!.data.length > 6
                    ? 6
                    : state.review!.data.length,
                itemBuilder: (context, index) {
                  final review = state.review!.data[index];
                  return ReviewCard(
                    imageUrl: review.reviewer.imagePath ?? "",
                    name: review.reviewer.name,
                    commentText: review.comments,
                    date: review.createdAt,
                    rate: review.rate,
                    id: review.id,
                    onTap: () {},
                  );
                },
              ),
              if (state.review!.data.length >= 6)
                SeeMoreButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewUserScreen(userId: userId),
                      ),
                    );
                  },
                ),
            ],
          );
        } else if (state is UserReviewFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(16),
                Text(
                  'No Reviews Yet',
                  style: AppStyles.semiBold16(
                    context,
                  ).copyWith(color: context.theme.black50),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
