import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/list_review_model.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/review_model.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  bool _isLoadingMore = false;
  int _pageVehicleReviews = 1, _pageUserReviews = 1;
  int _totalPagesVehicleReviews = 1, _totalPagesUserReviews = 1;

  final List<ReviewModel> _vehicleReviews = [];
  final List<ReviewModel> _userReviews = [];

  List<ReviewModel> get vehicleReviews => List.unmodifiable(_vehicleReviews);
  List<ReviewModel> get userReviews => List.unmodifiable(_userReviews);

  void _resetList(
      List<ReviewModel> list, int page, int totalPages, bool isVehicleReviews) {
    list.clear();
    if (isVehicleReviews) {
      _pageVehicleReviews = page;
      _totalPagesVehicleReviews = totalPages;
    } else {
      _pageUserReviews = page;
      _totalPagesUserReviews = totalPages;
    }
  }

  Future<void> getVehicleReviews(String vehicleId, String accessToken,
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        (_isLoadingMore || _pageVehicleReviews >= _totalPagesVehicleReviews))
      return;

    try {
      if (!isLoadMore) {
        emit(ReviewLoading());
        _resetList(_vehicleReviews, 1, 1, true);
      } else {
        _isLoadingMore = true;
        emit(ReviewLoadingMore(
          reviewModel: ListReviewModel(
            data: _vehicleReviews,
            totalPages: _totalPagesVehicleReviews,
            pageNumber: _pageVehicleReviews,
          ),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getVehicleReviews,
        queryParameters: {
          'vehicleId': vehicleId,
          'pageNo': isLoadMore ? _pageVehicleReviews + 1 : 1,
          'pageSize': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final reviews = ListReviewModel.fromJson(response);
      if (isLoadMore) {
        _vehicleReviews.addAll(reviews.data);
      } else {
        _vehicleReviews.clear();
        _vehicleReviews.addAll(reviews.data);
      }
      if (_vehicleReviews.length > 50) {
        _vehicleReviews.removeRange(0, _vehicleReviews.length - 50);
      }

      _pageVehicleReviews = isLoadMore ? _pageVehicleReviews + 1 : 1;
      _totalPagesVehicleReviews = reviews.totalPages;

      emit(ReviewSuccess(
        review: ListReviewModel(
          data: _vehicleReviews,
          totalPages: _totalPagesVehicleReviews,
          pageNumber: _pageVehicleReviews,
        ),
      ));
    } catch (e) {
      emit(ReviewFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> getUserReviews(String userId, String accessToken,
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        (_isLoadingMore || _pageUserReviews >= _totalPagesUserReviews)) return;

    try {
      if (!isLoadMore) {
        emit(ReviewLoading());
        _resetList(_userReviews, 1, 1, false);
      } else {
        _isLoadingMore = true;
        emit(ReviewLoadingMore(
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
          'pageSize': 10,
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

      emit(ReviewSuccess(
        review: ListReviewModel(
          data: _userReviews,
          totalPages: _totalPagesUserReviews,
          pageNumber: _pageUserReviews,
        ),
      ));
    } catch (e) {
      emit(ReviewFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  void loadMoreVehicleReviews(String vehicleId, String accessToken) =>
      getVehicleReviews(vehicleId, accessToken, isLoadMore: true);

  void loadMoreUserReviews(String userId, String accessToken) =>
      getUserReviews(userId, accessToken, isLoadMore: true);

  bool get canLoadMoreVehicleReviews =>
      _pageVehicleReviews < _totalPagesVehicleReviews && !_isLoadingMore;

  bool get canLoadMoreUserReviews =>
      _pageUserReviews < _totalPagesUserReviews && !_isLoadingMore;
}
