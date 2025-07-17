sealed class CreateReviewState {}

final class CreateReviewInitial extends CreateReviewState {}

final class CreateReviewLoading extends CreateReviewState {}

final class CreateReviewSuccess extends CreateReviewState {
  final String message;
  CreateReviewSuccess({required this.message});
}

final class CreateReviewFailure extends CreateReviewState {
  final String errorMessage;
  CreateReviewFailure({required this.errorMessage});
}
