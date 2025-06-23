import '../../../data/model/list_review_model.dart';

sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

final class ReviewSuccess extends ReviewState {
  final ListReviewModel? review;
  ReviewSuccess({this.review});
}

final class ReviewLoading extends ReviewState {}

final class ReviewLoadingMore extends ReviewState {
  final ListReviewModel reviewModel;
  ReviewLoadingMore({required this.reviewModel});
}

final class ReviewFailure extends ReviewState {
  final String errorMsg;
  ReviewFailure(this.errorMsg);
}
