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
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalDays: json['totalDays'],
      discount: (json['discount'] ?? 0.0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0.0).toDouble(),
      rentalStatus: json['rentalStatus'] ?? '',
      renterReview: json['renterReview'] != null
          ? Review.fromJson(json['renterReview'])
          : null,
      customerReview: json['customerReview'] != null
          ? Review.fromJson(json['customerReview'])
          : null,
      vehicle: Vehicle.fromJson(json['vehicle']),
      user: User.fromJson(json['user']),
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
      id: json['id'],
      rentalId: json['rentalId'],
      createdAt: DateTime.parse(json['createdAt']),
      behavior: (json['behavior'] ?? 0.0).toDouble(),
      punctuality: (json['punctuality'] ?? 0.0).toDouble(),
      comments: json['comments'] ?? '',
      care: json['care']?.toDouble(),
      truthfulness: json['truthfulness']?.toDouble(),
      reviewer: User.fromJson(json['reviewer']),
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
      id: json['id'],
      pricePerDay: (json['pricePerDay'] ?? 0.0).toDouble(),
      mainImagePath: json['mainImagePath'] ?? '',
      address: json['address'] ?? '',
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
      id: json['id'],
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath];
}
