class TargetCustomerReviewModel {
  final int id;
  final int rentalId;
  final String createdAt;
  final int behavior;
  final int punctuality;
  final String comments;
  final int truthfulness;

  TargetCustomerReviewModel({
    required this.id,
    required this.rentalId,
    required this.createdAt,
    required this.behavior,
    required this.punctuality,
    required this.comments,
    required this.truthfulness,
  });

  factory TargetCustomerReviewModel.fromJson(Map<String, dynamic> json) {
    return TargetCustomerReviewModel(
      id: json['id'],
      rentalId: json['rentalId'],
      createdAt: json['createdAt'],
      behavior: json['behavior'],
      punctuality: json['punctuality'],
      comments: json['comments'],
      truthfulness: json['truthfulness'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rentalId': rentalId,
      'createdAt': createdAt,
      'behavior': behavior,
      'punctuality': punctuality,
      'comments': comments,
      'truthfulness': truthfulness,
    };
  }
}
