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
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json[ApiKey.getVehicleId],
      distance: json[ApiKey.getVehicleDistance],
      brand: json[ApiKey.getVehicleBrand],
      type: json[ApiKey.getVehicleType],
      model: json[ApiKey.getVehicleModel],
      year: json[ApiKey.getVehicleYear],
      pricePerDay: json[ApiKey.getVehiclePricePerDay],
      isFavourite: json[ApiKey.getVehicleIsFavourite],
      mainImagePath: json[ApiKey.getVehicleMainImagePath],
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
    };
  }
}
