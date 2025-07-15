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
    required double behavior,
    required double punctuality,
    required String comments,
    double? care,
    double? truthfulness,
  }) async {
    try {
      emit(CreateReviewLoading());

      final reviewData = {
        'rentalId': rentalId,
        'behavior': behavior,
        'punctuality': punctuality,
        'comments': comments,
      };

      if (care != null) {
        reviewData['care'] = care;
      }
      if (truthfulness != null) {
        reviewData['truthfulness'] = truthfulness;
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
