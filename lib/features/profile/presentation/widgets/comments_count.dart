import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsCount extends StatelessWidget {
  const CommentsCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCountCubit, ReviewCountState>(
      builder: (context, state) {
        if (state is ReviewUserSuccess) {
          return Row(
            spacing: 8,
            children: [
              Icon(
                Icons.map_outlined,
                size: 18,
                color: context.theme.blue100_2,
              ),
              Text(
                'Comments (${state.review})',
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(color: context.theme.black100),
              ),
            ],
          );
        } else {
          return Row(
            spacing: 8,
            children: [
              Icon(
                Icons.map_outlined,
                size: 18,
                color: context.theme.blue100_2,
              ),
              Text(
                'Comments (0)',
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(color: context.theme.black100),
              ),
            ],
          );
        }
      },
    );
  }
}
