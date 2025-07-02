import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_styles.dart';

class ReviewCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String commentText;
  final String date;
  final double rate;
  final int id;
  final VoidCallback? onTap;

  const ReviewCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.commentText,
    required this.date,
    required this.rate,
    required this.id,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = date;
    final parsedDate = DateTime.parse(date);
    formattedDate = DateFormat('MMM d, yyyy').format(parsedDate);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.theme.grey100_1.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              imageUrl.isNotEmpty
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(EndPoint.baseUrl + imageUrl),
                      onBackgroundImageError: (_, __) => Text(
                        name.isNotEmpty ? name[0] : '?',
                        style: AppStyles.bold16(context).copyWith(
                          color: context.theme.blue100_1,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: context.theme.blue100_1.withOpacity(0.1),
                      child: Text(
                        name.isNotEmpty ? name[0] : '?',
                        style: AppStyles.bold16(context).copyWith(
                          color: context.theme.blue100_1,
                        ),
                      ),
                    ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppStyles.bold14(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              Icons.star,
                              size: 14,
                              color: starIndex < rate
                                  ? Colors.amber
                                  : context.theme.grey100_1,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          formattedDate,
                          style: AppStyles.medium12(context).copyWith(
                            color: context.theme.black50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            commentText,
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.black50,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
