import 'package:equatable/equatable.dart';

class RentalHistoryItem extends Equatable {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final double discount;
  final double finalPrice;
  final String rentalStatus;
  final Review? renterReview;
  final Review? customerReview;
  final Vehicle vehicle;
  final User user;

  const RentalHistoryItem({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.discount,
    required this.finalPrice,
    required this.rentalStatus,
    this.renterReview,
    this.customerReview,
    required this.vehicle,
    required this.user,
  });

  factory RentalHistoryItem.fromJson(Map<String, dynamic> json) {
    return RentalHistoryItem(
      id: json['Id'],
      startDate: DateTime.parse(json['StartDate']),
      endDate: DateTime.parse(json['EndDate']),
      totalDays: json['TotalDays'],
      discount: json['Discount']?.toDouble() ?? 0.0,
      finalPrice: json['FinalPrice']?.toDouble() ?? 0.0,
      rentalStatus: json['RentalStatus'],
      renterReview: json['RenterReview'] != null
          ? Review.fromJson(json['RenterReview'])
          : null,
      customerReview: json['CustomerReview'] != null
          ? Review.fromJson(json['CustomerReview'])
          : null,
      vehicle: Vehicle.fromJson(json['Vehicle']),
      user: User.fromJson(json['User']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        totalDays,
        discount,
        finalPrice,
        rentalStatus,
        renterReview,
        customerReview,
        vehicle,
        user,
      ];
}

class Review extends Equatable {
  final int id;
  final int rentalId;
  final DateTime createdAt;
  final double behavior;
  final double punctuality;
  final String comments;
  final double? care; // Only in RenterReview
  final double? truthfulness; // Only in CustomerReview
  final User reviewer;

  const Review({
    required this.id,
    required this.rentalId,
    required this.createdAt,
    required this.behavior,
    required this.punctuality,
    required this.comments,
    this.care,
    this.truthfulness,
    required this.reviewer,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['Id'],
      rentalId: json['RentalId'],
      createdAt: DateTime.parse(json['CreatedAt']),
      behavior: json['Behavior']?.toDouble() ?? 0.0,
      punctuality: json['Punctuality']?.toDouble() ?? 0.0,
      comments: json['Comments'] ?? '',
      care: json['Care']?.toDouble(),
      truthfulness: json['Truthfulness']?.toDouble(),
      reviewer: User.fromJson(json['Reviewer']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        rentalId,
        createdAt,
        behavior,
        punctuality,
        comments,
        care,
        truthfulness,
        reviewer,
      ];
}

class Vehicle extends Equatable {
  final int id;
  final double pricePerDay;
  final String mainImagePath;
  final String address;

  const Vehicle({
    required this.id,
    required this.pricePerDay,
    required this.mainImagePath,
    required this.address,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['Id'],
      pricePerDay: json['PricePerDay']?.toDouble() ?? 0.0,
      mainImagePath: json['MainImagePath'] ?? '',
      address: json['Address'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, pricePerDay, mainImagePath, address];
}

class User extends Equatable {
  final int id;
  final String name;
  final String imagePath;

  const User({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Id'],
      name: json['Name'] ?? '',
      imagePath: json['ImagePath'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath];
}
