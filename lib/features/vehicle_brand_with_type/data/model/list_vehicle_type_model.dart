import 'package:aggar/features/vehicle_brand_with_type/data/model/vehicle_type_model.dart';

class ListVehicleTypeModel {
  final List<VehicleTypeModel> data;

  ListVehicleTypeModel({
    required this.data,
  });

  factory ListVehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return ListVehicleTypeModel(
      data: (json['data'] as List<dynamic>)
          .map((vehicleJson) =>
              VehicleTypeModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((vehicle) => vehicle.toJson()).toList(),
    };
  }
}
