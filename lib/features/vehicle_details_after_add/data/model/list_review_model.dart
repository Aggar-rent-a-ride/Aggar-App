import 'package:aggar/features/vehicle_details_after_add/data/model/review_model.dart';

class ListReviewModel {
  final List<ReviewModel> data;
  final int totalPages;
  final int pageNumber;

  const ListReviewModel({
    required this.totalPages,
    required this.pageNumber,
    required this.data,
  });

  factory ListReviewModel.fromJson(Map<String, dynamic> json) {
    return ListReviewModel(
      data: (json['data']['data'] as List<dynamic>)
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['data']['totalPages'] as int,
      pageNumber: json['data']['pageNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'data': data.map((review) => review.toJson()).toList(),
        'totalPages': totalPages,
        'pageNumber': pageNumber,
      },
    };
  }
}
