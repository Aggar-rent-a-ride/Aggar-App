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
      status: json['status'] ?? json['Status'] ?? '',
      vehicleId: json['vehicleId'] ?? json['VehicleId'] ?? 0,
      startDate: DateTime.parse(json['startDate'] ?? json['StartDate']),
      endDate: DateTime.parse(json['endDate'] ?? json['EndDate']),
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
