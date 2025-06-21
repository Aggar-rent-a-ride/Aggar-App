import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/list_review_model.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  Future<void> getVehicleReviews(String vehicleId, String accessToken) async {
    try {
      emit(ReviewLoading());
      final response = await dioConsumer.get(
        EndPoint.getVehicleReviews,
        queryParameters: {
          'vehicleId': vehicleId,
          'pageNo': 1,
          'pageSize': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final ListReviewModel reviews = ListReviewModel.fromJson(response);
      await Future.delayed(const Duration(seconds: 2));
      emit(
        ReviewVehicleSuccess(
          review: reviews,
        ),
      );
    } catch (e) {
      emit(ReviewFailure(e.toString()));
    }
  }

  Future<void> getUSerReviews(String userId, String accessToken) async {
    try {
      emit(ReviewLoading());
      final response = await dioConsumer.get(
        EndPoint.getUserReviews,
        queryParameters: {
          'userId': userId,
          'pageNo': 1,
          'pageSize': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final reviews = ListReviewModel.fromJson(response);
      print(reviews);
      await Future.delayed(const Duration(seconds: 2));
      emit(
        ReviewVehicleSuccess(
          review: reviews,
        ),
      );
    } catch (e) {
      emit(ReviewFailure(e.toString()));
    }
  }
}
