import 'package:aggar/core/api/end_points.dart';

class VehicleBrand {
  final int id;
  final String name;
  final String country;
  final String logo;

  VehicleBrand({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
  });

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    return VehicleBrand(
      id: json[ApiKey.vehicleBrandId],
      name: json[ApiKey.vehicleBrandName],
      country: json[ApiKey.vehicleBrandCountry],
      logo: json[ApiKey.vehicleBrandLogo],
    );
  }
}
