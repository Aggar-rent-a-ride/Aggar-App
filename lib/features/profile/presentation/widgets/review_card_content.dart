import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/widgets/image_with_name_and_rate_row.dart';
import 'package:flutter/material.dart';

class ReviewCardContent extends StatelessWidget {
  const ReviewCardContent({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.rate,
    required this.commentText,
  });

  final String imageUrl;
  final String name;
  final String date;
  final double rate;
  final String commentText;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageWithNameAndRateRow(
          imageUrl: imageUrl,
          name: name,
          date: date,
          rate: rate,
        ),
        Text(
          commentText,
          style: AppStyles.medium16(context).copyWith(
            color: context.theme.gray100_2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
