import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/customer_review_target_type_card.dart';
import 'package:flutter/material.dart';

class CustomerReviewTargetType extends StatelessWidget {
  const CustomerReviewTargetType({super.key, required this.state});
  final ReportByIdLoaded state;

  @override
  Widget build(BuildContext context) {
    return CustomerReviewTargetTypeCard(
      behavior: (state.report.targetCustomerReview!.behavior).toDouble(),
      truthfulness: (state.report.targetCustomerReview!.truthfulness)
          .toDouble(),
      comments: state.report.targetCustomerReview!.comments,
      createdAt: state.report.targetCustomerReview!.createdAt,
      punctuality: (state.report.targetCustomerReview!.punctuality).toDouble(),
      rentalId: state.report.targetCustomerReview!.rentalId,
    );
  }
}
