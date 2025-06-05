import 'package:aggar/features/vehicle_details_after_add/data/model/review_model.dart';

class ListReviewModel {
  final List<ReviewModel> data;

  const ListReviewModel({
    required this.data,
  });

  factory ListReviewModel.fromJson(Map<String, dynamic> json) {
    return ListReviewModel(
      data: (json['data']['data'] as List<dynamic>)
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'data': data.map((review) => review.toJson()).toList(),
      },
    };
  }
}
