import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/comment_section.dart';

class ReviewUserSection extends StatelessWidget {
  const ReviewUserSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ReviewSuccess) {
          final vehicles = state.review!.data;
          if (vehicles.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite,
                        size: 50, color: context.theme.blue100_2),
                    const SizedBox(height: 10),
                    Text(
                      'No saved vehicles yet',
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.gray100_2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: vehicles
                  .asMap()
                  .entries
                  .map(
                    (entry) => CommentSection(
                      imageUrl: entry.value.reviewer.imagePath ?? "",
                      name: entry.value.reviewer.name,
                      commentText: entry.value.comments,
                      date: DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(entry.value.createdAt)),
                      rate: entry.value.rate,
                      id: entry.value.id,
                      typeOfReport: "CustomerReview",
                    ),
                  )
                  .toList(),
            ),
          );
        } else if (state is ReviewFailure) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Error: ${state.errorMsg}',
                style: AppStyles.medium16(context).copyWith(
                  color: context.theme.gray100_2,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 50, color: context.theme.blue100_2),
                const SizedBox(height: 10),
                Text(
                  'No saved vehicles yet',
                  style: AppStyles.medium16(context).copyWith(
                    color: context.theme.gray100_2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
