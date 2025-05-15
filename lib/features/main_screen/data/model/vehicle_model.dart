import 'package:aggar/core/api/end_points.dart';

class VehicleModel {
  final int id;
  final num distance;
  final String brand;
  final String type;
  final String model;
  final int year;
  final double pricePerDay;
  final bool isFavourite;
  final String mainImagePath;
  final String transmission;
  final double? rate;

  const VehicleModel({
    required this.id,
    required this.distance,
    required this.brand,
    required this.type,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.isFavourite,
    required this.mainImagePath,
    required this.transmission,
    this.rate,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json[ApiKey.getVehicleId],
      distance: json[ApiKey.getVehicleDistance],
      brand: json[ApiKey.getVehicleBrand],
      type: json[ApiKey.getVehicleType],
      model: json[ApiKey.getVehicleModel],
      year: json[ApiKey.getVehicleYear],
      pricePerDay: (json[ApiKey.getVehiclePricePerDay] ?? 0.0).toDouble(),
      isFavourite: json[ApiKey.getVehicleIsFavourite] ?? false,
      mainImagePath: json[ApiKey.getVehicleMainImagePath],
      transmission: json[ApiKey.getVehicleTransmission],
      rate: json[ApiKey.getVehicleRate] != null
          ? (json[ApiKey.getVehicleRate]).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getVehicleId: id,
      ApiKey.getVehicleDistance: distance,
      ApiKey.getVehicleBrand: brand,
      ApiKey.getVehicleType: type,
      ApiKey.getVehicleModel: model,
      ApiKey.getVehicleYear: year,
      ApiKey.getVehiclePricePerDay: pricePerDay,
      ApiKey.getVehicleIsFavourite: isFavourite,
      ApiKey.getVehicleMainImagePath: mainImagePath,
      ApiKey.getVehicleTransmission: transmission,
      ApiKey.getVehicleRate: rate,
    };
  }
}
