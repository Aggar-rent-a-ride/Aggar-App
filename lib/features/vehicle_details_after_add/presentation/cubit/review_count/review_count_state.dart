sealed class ReviewCountState {}

final class ReviewCountInitial extends ReviewCountState {}

final class ReviewVehicleSuccess extends ReviewCountState {
  final int? review;
  ReviewVehicleSuccess({this.review});
}

final class ReviewCountLoading extends ReviewCountState {}

final class ReviewCountFailure extends ReviewCountState {
  final String errorMsg;

  ReviewCountFailure(this.errorMsg);
}
