class TargetRenterReviewModel {
  final int id;
  final int rentalId;
  final String createdAt;
  final int behavior;
  final int punctuality;
  final String comments;
  final int care;

  TargetRenterReviewModel({
    required this.id,
    required this.rentalId,
    required this.createdAt,
    required this.behavior,
    required this.punctuality,
    required this.comments,
    required this.care,
  });

  factory TargetRenterReviewModel.fromJson(Map<String, dynamic> json) {
    return TargetRenterReviewModel(
      id: json['id'],
      rentalId: json['rentalId'],
      createdAt: json['createdAt'],
      behavior: json['behavior'],
      punctuality: json['punctuality'],
      comments: json['comments'],
      care: json['care'],
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
      'care': care,
    };
  }
}
