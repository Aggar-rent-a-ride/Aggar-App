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
  int _pageVehicleReviews = 1;
  int _totalPagesVehicleReviews = 1;

  final List<ReviewModel> _vehicleReviews = [];

  List<ReviewModel> get vehicleReviews => List.unmodifiable(_vehicleReviews);

  void _resetList(List<ReviewModel> list, int page, int totalPages) {
    list.clear();
    _pageVehicleReviews = page;
    _totalPagesVehicleReviews = totalPages;
  }

  Future<void> getVehicleReviews(String vehicleId, String accessToken,
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        (_isLoadingMore || _pageVehicleReviews >= _totalPagesVehicleReviews))
      return;

    try {
      if (!isLoadMore) {
        emit(ReviewLoading());
        _resetList(_vehicleReviews, 1, 1);
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

  void loadMoreVehicleReviews(String vehicleId, String accessToken) =>
      getVehicleReviews(vehicleId, accessToken, isLoadMore: true);

  bool get canLoadMoreVehicleReviews =>
      _pageVehicleReviews < _totalPagesVehicleReviews && !_isLoadingMore;
}
