import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_brand_model.dart';

class ListVehicleBrandModel {
  final List<VehicleBrandModel> data;

  ListVehicleBrandModel({
    required this.data,
  });

  factory ListVehicleBrandModel.fromJson(Map<String, dynamic> json) {
    return ListVehicleBrandModel(
      data: (json['data'] as List<dynamic>)
          .map((vehicleJson) =>
              VehicleBrandModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((vehicle) => vehicle.toJson()).toList(),
    };
  }
}
