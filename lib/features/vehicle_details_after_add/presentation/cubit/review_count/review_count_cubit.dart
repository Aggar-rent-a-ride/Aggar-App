import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class ReviewCountCubit extends Cubit<ReviewCountState> {
  ReviewCountCubit() : super(ReviewCountInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  Future<void> getReviewsNumber(String vehicleId, String accessToken) async {
    try {
      emit(ReviewCountLoading());
      final response = await dioConsumer.get(
        "${EndPoint.getVehicleReviews}?vehicleId=$vehicleId&pageNo=1&pageSize=1",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      emit(ReviewVehicleSuccess(review: response["data"]["totalPages"]));
    } catch (e) {
      emit(ReviewCountFailure(e.toString()));
    }
  }
}
