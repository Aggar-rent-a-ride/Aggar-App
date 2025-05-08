import 'package:aggar/features/main_screen/data/model/vehicle_model.dart';

class ListVehicleModel {
  final List<VehicleModel> data;

  ListVehicleModel({
    required this.data,
  });
  factory ListVehicleModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      var nestedData = json['data'] as Map<String, dynamic>;
      if (nestedData.containsKey('data') && nestedData['data'] is List) {
        List<dynamic> vehiclesJson = nestedData['data'] as List;
        List<VehicleModel> vehicles = vehiclesJson
            .map((vehicleJson) =>
                VehicleModel.fromJson(vehicleJson as Map<String, dynamic>))
            .toList();
        return ListVehicleModel(data: vehicles);
      }
    }

    if (json.containsKey('data') && json['data'] is List) {
      List<dynamic> vehiclesJson = json['data'] as List;
      List<VehicleModel> vehicles = vehiclesJson
          .map((vehicleJson) =>
              VehicleModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList();
      return ListVehicleModel(data: vehicles);
    }
    return ListVehicleModel(data: []);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((vehicle) => vehicle.toJson()).toList(),
    };
  }
}
