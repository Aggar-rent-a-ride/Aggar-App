import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/renter_review_target_type_card.dart';
import 'package:flutter/material.dart';

class RenterReviewTargetType extends StatelessWidget {
  const RenterReviewTargetType({super.key, required this.state});
  final ReportByIdLoaded state;
  @override
  Widget build(BuildContext context) {
    return RenterReviewTargetTypeCard(
      behavior: (state.report.targetRenterReview!.behavior).toDouble(),
      care: (state.report.targetRenterReview!.care).toDouble(),
      comments: state.report.targetRenterReview!.comments,
      createdAt: state.report.targetRenterReview!.createdAt,
      punctuality: (state.report.targetRenterReview!.punctuality).toDouble(),
      rentalId: state.report.targetRenterReview!.rentalId,
    );
  }
}
