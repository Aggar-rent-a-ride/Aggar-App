import 'package:aggar/core/api/end_points.dart';

class VehicleBrandModel {
  final int id;
  final String name;
  final String country;
  final String? logoPath;

  VehicleBrandModel({
    required this.id,
    required this.name,
    required this.country,
    this.logoPath,
  });

  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) {
    return VehicleBrandModel(
      id: json[ApiKey.vehicleBrandId] as int,
      name: json[ApiKey.vehicleBrandName] as String,
      country: json[ApiKey.vehicleBrandCountry] as String,
      logoPath: json[ApiKey.vehicleBrandLogo] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.vehicleBrandId: id,
      ApiKey.vehicleBrandName: name,
      ApiKey.vehicleBrandCountry: country,
      ApiKey.vehicleBrandLogo: logoPath,
    };
  }
}
