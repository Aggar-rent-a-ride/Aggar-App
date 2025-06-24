import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/profile/presentation/widgets/review_card_content.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String commentText;
  final String date;
  final double rate;
  final int id;
  final String typeOfReport;
  final VoidCallback? onTap;

  const ReviewCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.commentText,
    required this.date,
    required this.rate,
    required this.id,
    required this.typeOfReport,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ReviewCardContent(
            imageUrl: imageUrl,
            name: name,
            date: date,
            rate: rate,
            commentText: commentText,
          ),
        ),
      ),
    );
  }
}
