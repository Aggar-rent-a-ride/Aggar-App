import 'package:equatable/equatable.dart';

class BookingModel {
  final int id;
  final int totalDays;
  final double price;
  final double finalPrice;
  final double discount;
  final String? vehicleImagePath;
  final int vehicleYear;
  final String vehicleModel;
  final String? vehicleBrand;
  final String? vehicleType;
  final String status;
  final int vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final int? customerId;
  final String? customerName;

  BookingModel({
    required this.id,
    required this.totalDays,
    required this.price,
    required this.finalPrice,
    required this.discount,
    this.vehicleImagePath,
    required this.vehicleYear,
    required this.vehicleModel,
    this.vehicleBrand,
    this.vehicleType,
    required this.status,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    this.customerId,
    this.customerName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? json['Id'] ?? 0,
      totalDays: json['totalDays'] ?? json['TotalDays'] ?? 0,
      price: (json['price'] ?? json['Price'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? json['FinalPrice'] ?? 0).toDouble(),
      discount: (json['discount'] ?? json['Discount'] ?? 0).toDouble(),
      vehicleImagePath: json['vehicleImagePath'] ?? json['VehicleImagePath'],
      vehicleYear: json['vehicleYear'] ?? json['VehicleYear'] ?? 0,
      vehicleModel: json['vehicleModel'] ?? json['VehicleModel'] ?? '',
      vehicleBrand: json['vehicleBrand'] ?? json['VehicleBrand'],
      vehicleType: json['vehicleType'] ?? json['VehicleType'],
      status: json['Status'] ?? json['status'] ?? '',
      vehicleId: json['vehicleId'] ?? json['VehicleId'] ?? 0,
      startDate: DateTime.parse(json['startDate'] ?? json['StartDate']),
      endDate: DateTime.parse(json['endDate'] ?? json['EndDate']),
      customerId: json['customerId'] ?? json['CustomerId'],
      customerName: json['customerName'] ?? json['CustomerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalDays': totalDays,
      'price': price,
      'finalPrice': finalPrice,
      'discount': discount,
      'vehicleImagePath': vehicleImagePath,
      'vehicleYear': vehicleYear,
      'vehicleModel': vehicleModel,
      'vehicleBrand': vehicleBrand,
      'vehicleType': vehicleType,
      'status': status,
      'vehicleId': vehicleId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'customerId': customerId,
      'customerName': customerName,
    };
  }

  BookingModel copyWith({
    int? id,
    int? totalDays,
    double? price,
    double? finalPrice,
    double? discount,
    String? vehicleImagePath,
    int? vehicleYear,
    String? vehicleModel,
    String? vehicleBrand,
    String? vehicleType,
    String? status,
    int? vehicleId,
    DateTime? startDate,
    DateTime? endDate,
    int? customerId,
    String? customerName,
  }) {
    return BookingModel(
      id: id ?? this.id,
      totalDays: totalDays ?? this.totalDays,
      price: price ?? this.price,
      finalPrice: finalPrice ?? this.finalPrice,
      discount: discount ?? this.discount,
      vehicleImagePath: vehicleImagePath ?? this.vehicleImagePath,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      vehicleId: vehicleId ?? this.vehicleId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
    );
  }
}

class BookingRequest {
  final int vehicleId;
  final DateTime startDate;
  final DateTime endDate;

  BookingRequest({
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'VehicleId': vehicleId,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
    };
  }
}

enum BookingStatus {
  pending('Pending'),
  rejected('Rejected'),
  accepted('Accepted'),
  canceled('Canceled'),
  confirmed('Confirmed');

  const BookingStatus(this.value);
  final String value;

  static BookingStatus fromString(String status) {
    return BookingStatus.values.firstWhere(
      (s) => s.value.toLowerCase() == status.toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }
}

class BookingsResponse {
  final List<BookingModel> data;
  final int totalPages;
  final int pageNumber;
  final int pageSize;

  BookingsResponse({
    required this.data,
    required this.totalPages,
    required this.pageNumber,
    required this.pageSize,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    return BookingsResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => BookingModel.fromJson(item))
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
    );
  }
}

class BookingHistoryModel extends Equatable {
  final int id;
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleType;
  final DateTime startDate;
  final DateTime endDate;
  final double finalPrice;
  final String bookingStatus;

  const BookingHistoryModel({
    required this.id,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleType,
    required this.startDate,
    required this.endDate,
    required this.finalPrice,
    required this.bookingStatus,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingHistoryModel(
      id: json['id'] as int,
      vehicleBrand: json['vehicleBrand'] as String,
      vehicleModel: json['vehicleModel'] as String,
      vehicleType: json['vehicleType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      bookingStatus: json['bookingStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleBrand': vehicleBrand,
      'vehicleModel': vehicleModel,
      'vehicleType': vehicleType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'finalPrice': finalPrice,
      'bookingStatus': bookingStatus,
    };
  }

  BookingHistoryModel copyWith({
    int? id,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleType,
    DateTime? startDate,
    DateTime? endDate,
    double? finalPrice,
    String? bookingStatus,
  }) {
    return BookingHistoryModel(
      id: id ?? this.id,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleType: vehicleType ?? this.vehicleType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      finalPrice: finalPrice ?? this.finalPrice,
      bookingStatus: bookingStatus ?? this.bookingStatus,
    );
  }

  // Getter for status enum if you have one
  BookingStatus get status {
    switch (bookingStatus.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'accepted':
        return BookingStatus.accepted;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'canceled':
      case 'cancelled':
        return BookingStatus.canceled;
      default:
        return BookingStatus.pending;
    }
  }

  // Helper getters
  bool get isPending => bookingStatus.toLowerCase() == 'pending';
  bool get isAccepted => bookingStatus.toLowerCase() == 'accepted';
  bool get isConfirmed => bookingStatus.toLowerCase() == 'confirmed';
  bool get isCanceled =>
      bookingStatus.toLowerCase() == 'canceled' ||
      bookingStatus.toLowerCase() == 'cancelled';

  // Duration calculation
  Duration get duration => endDate.difference(startDate);

  // Days calculation
  int get durationInDays => duration.inDays;

  @override
  List<Object?> get props => [
        id,
        vehicleBrand,
        vehicleModel,
        vehicleType,
        startDate,
        endDate,
        finalPrice,
        bookingStatus,
      ];

  @override
  String toString() {
    return 'BookingHistoryModel(id: $id, vehicleBrand: $vehicleBrand, vehicleModel: $vehicleModel, vehicleType: $vehicleType, startDate: $startDate, endDate: $endDate, finalPrice: $finalPrice, bookingStatus: $bookingStatus)';
  }
}
