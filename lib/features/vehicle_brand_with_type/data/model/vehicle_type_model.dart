import 'package:aggar/core/api/end_points.dart';

class VehicleTypeModel {
  final int id;
  final String name;
  final String? slogenPath;

  VehicleTypeModel({
    required this.id,
    required this.name,
    this.slogenPath,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json[ApiKey.vehicleTypeId] as int,
      name: json[ApiKey.vehicleTypeName] as String,
      slogenPath: json[ApiKey.vehicleTypeSlogen] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.vehicleTypeId: id,
      ApiKey.vehicleTypeName: name,
      ApiKey.vehicleTypeSlogen: slogenPath,
    };
  }
}
