import 'package:aggar/core/api/end_points.dart';

class VehicleType {
  final int id;
  final String name;
  final String slogenPath;

  VehicleType({
    required this.id,
    required this.name,
    required this.slogenPath,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json[ApiKey.vehicleTypeId],
      name: json[ApiKey.vehicleTypeName],
      slogenPath: json[ApiKey.vehicleTypeSlogen],
    );
  }
}
