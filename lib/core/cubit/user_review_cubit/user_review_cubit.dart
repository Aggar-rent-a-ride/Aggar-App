import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/user_review_cubit/user_review_state.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/list_review_model.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/review_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class UserReviewCubit extends Cubit<UserReviewState> {
  UserReviewCubit() : super(UserReviewInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  bool _isLoadingMore = false;
  int _pageUserReviews = 1;
  int _totalPagesUserReviews = 1;

  final List<ReviewModel> _userReviews = [];

  List<ReviewModel> get userReviews => List.unmodifiable(_userReviews);

  void _resetList(List<ReviewModel> list, int page, int totalPages) {
    list.clear();
    _pageUserReviews = page;
    _totalPagesUserReviews = totalPages;
  }

  Future<void> getUserReviews(String userId, String accessToken,
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        (_isLoadingMore || _pageUserReviews >= _totalPagesUserReviews)) return;

    try {
      if (!isLoadMore) {
        emit(UserReviewLoading());
        _resetList(_userReviews, 1, 1);
      } else {
        _isLoadingMore = true;
        emit(UserReviewLoadingMore(
          reviewModel: ListReviewModel(
            data: _userReviews,
            totalPages: _totalPagesUserReviews,
            pageNumber: _pageUserReviews,
          ),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getUserReviews,
        queryParameters: {
          'userId': userId,
          'pageNo': isLoadMore ? _pageUserReviews + 1 : 1,
          'pageSize': 8,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final reviews = ListReviewModel.fromJson(response);
      if (isLoadMore) {
        _userReviews.addAll(reviews.data);
      } else {
        _userReviews.clear();
        _userReviews.addAll(reviews.data);
      }
      if (_userReviews.length > 50) {
        _userReviews.removeRange(0, _userReviews.length - 50);
      }

      _pageUserReviews = isLoadMore ? _pageUserReviews + 1 : 1;
      _totalPagesUserReviews = reviews.totalPages;

      emit(UserReviewSuccess(
        review: ListReviewModel(
          data: _userReviews,
          totalPages: _totalPagesUserReviews,
          pageNumber: _pageUserReviews,
        ),
      ));
    } catch (e) {
      emit(UserReviewFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  void loadMoreUserReviews(String userId, String accessToken) =>
      getUserReviews(userId, accessToken, isLoadMore: true);

  bool get canLoadMoreUserReviews =>
      _pageUserReviews < _totalPagesUserReviews && !_isLoadingMore;
}
