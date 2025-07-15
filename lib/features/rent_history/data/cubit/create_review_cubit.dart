import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/rent_history/data/cubit/create_review_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class CreateReviewCubit extends Cubit<CreateReviewState> {
  CreateReviewCubit() : super(CreateReviewInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  Future<void> createReview({
    required String accessToken,
    required int rentalId,
    required int behavior,
    required int punctuality,
    required String comments,
    int? care,
    int? truthfulness,
  }) async {
    try {
      emit(CreateReviewLoading());

      final reviewData = {
        'rentalId': rentalId,
        'behavior': behavior.toDouble(), // Convert to double as per API
        'punctuality': punctuality.toDouble(), // Convert to double as per API
        'comments': comments,
      };

      // Add care for renter review or truthfulness for customer review
      if (care != null) {
        reviewData['care'] = care.toDouble(); // Convert to double as per API
      }
      if (truthfulness != null) {
        reviewData['truthfulness'] =
            truthfulness.toDouble(); // Convert to double as per API
      }

      final response = await dioConsumer.post(
        EndPoint.createReview,
        data: reviewData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      emit(CreateReviewSuccess(message: 'Review submitted successfully!'));
    } catch (e) {
      emit(CreateReviewFailure(errorMessage: e.toString()));
    }
  }

  void reset() {
    emit(CreateReviewInitial());
  }
}
