part of 'review_cubit.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

final class ReviewSuccess extends ReviewState {}

final class ReviewVehicleSuccess extends ReviewState {
  final ListReviewModel? review;
  ReviewVehicleSuccess({this.review});
}

final class ReviewLoading extends ReviewState {}

final class ReviewFailure extends ReviewState {
  final String errorMsg;

  ReviewFailure(this.errorMsg);
}
