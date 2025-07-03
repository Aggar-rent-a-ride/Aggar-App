import 'package:aggar/features/vehicle_details_after_add/data/model/list_review_model.dart';

sealed class UserReviewState {}

final class UserReviewInitial extends UserReviewState {}

final class UserReviewSuccess extends UserReviewState {
  final ListReviewModel? review;
  UserReviewSuccess({this.review});
}

final class UserReviewLoading extends UserReviewState {}

final class UserReviewLoadingMore extends UserReviewState {
  final ListReviewModel reviewModel;
  UserReviewLoadingMore({required this.reviewModel});
}

final class UserReviewFailure extends UserReviewState {
  final String errorMsg;
  UserReviewFailure(this.errorMsg);
}
