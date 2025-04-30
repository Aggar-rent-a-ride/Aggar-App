import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/user_model.dart';

class ReviewModel {
  final int id;
  final UserModel reviewer;
  final String createdAt;
  final double rate;
  final String comments;

  const ReviewModel({
    required this.id,
    required this.reviewer,
    required this.createdAt,
    required this.rate,
    required this.comments,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json[ApiKey.getVehicleReviewId],
      reviewer: UserModel.fromJson(json[ApiKey.getVehicleReviewer]),
      createdAt: json[ApiKey.getVehicleCreatedAt],
      rate: json[ApiKey.getVehicleRate],
      comments: json[ApiKey.getVehicleComments],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getVehicleReviewId: id,
      ApiKey.getVehicleReviewer: reviewer.toJson(),
      ApiKey.getVehicleCreatedAt: createdAt,
      ApiKey.getVehicleRate: rate,
      ApiKey.getVehicleComments: comments,
    };
  }
}
