import 'package:equatable/equatable.dart';

class RentalHistoryResponse extends Equatable {
  final RentalHistoryData data;
  final int statusCode;

  const RentalHistoryResponse({
    required this.data,
    required this.statusCode,
  });

  factory RentalHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RentalHistoryResponse(
      data: RentalHistoryData.fromJson(json['data']),
      statusCode: json['statusCode'] ?? 200,
    );
  }

  @override
  List<Object?> get props => [data, statusCode];
}

class RentalHistoryData extends Equatable {
  final List<RentalHistoryItem> data;
  final int totalPages;
  final int pageNumber;
  final int pageSize;

  const RentalHistoryData({
    required this.data,
    required this.totalPages,
    required this.pageNumber,
    required this.pageSize,
  });

  factory RentalHistoryData.fromJson(Map<String, dynamic> json) {
    return RentalHistoryData(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => RentalHistoryItem.fromJson(item))
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 1,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }

  @override
  List<Object?> get props => [data, totalPages, pageNumber, pageSize];
}

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
      id: json['id'] ?? 0,
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      totalDays: json['totalDays'] ?? 0,
      discount: (json['discount'] ?? 0.0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0.0).toDouble(),
      rentalStatus: json['rentalStatus'] ?? '',
      renterReview: json['renterReview'] != null
          ? Review.fromJson(json['renterReview'])
          : null,
      customerReview: json['customerReview'] != null
          ? Review.fromJson(json['customerReview'])
          : null,
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
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
  final int behavior;
  final int punctuality;
  final String comments;
  final int? care; // Only in RenterReview
  final int? truthfulness; // Only in CustomerReview
  final Reviewer reviewer;

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
      id: json['id'] ?? 0,
      rentalId: json['rentalId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      behavior: json['behavior'] ?? 0,
      punctuality: json['punctuality'] ?? 0,
      comments: json['comments'] ?? '',
      care: json['care'],
      truthfulness: json['truthfulness'],
      reviewer: Reviewer.fromJson(json['reviewer'] ?? {}),
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

class Reviewer extends Equatable {
  final int id;
  final String name;
  final String? imagePath;

  const Reviewer({
    required this.id,
    required this.name,
    this.imagePath,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imagePath: json['imagePath'],
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath];
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
      id: json['id'] ?? 0,
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
  final String? imagePath;

  const User({
    required this.id,
    required this.name,
    this.imagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imagePath: json['imagePath'],
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath];
}