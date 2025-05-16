import 'package:aggar/features/main_screen/data/model/vehicle_model.dart';

class ListVehicleModel {
  final List<VehicleModel> data;
  final int? totalPages;
  final int? pageNumber;
  final int? pageSize;

  ListVehicleModel({
    required this.data,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
  });

  factory ListVehicleModel.fromJson(Map<String, dynamic> json) {
    print('ListVehicleModel fromJson: Input JSON: $json');
    List<VehicleModel> vehicles = [];
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      var nestedData = json['data'] as Map<String, dynamic>;
      if (nestedData.containsKey('data') && nestedData['data'] is List) {
        vehicles = (nestedData['data'] as List)
            .map((vehicleJson) =>
                VehicleModel.fromJson(vehicleJson as Map<String, dynamic>))
            .toList();
      }
    } else if (json.containsKey('data') && json['data'] is List) {
      vehicles = (json['data'] as List)
          .map((vehicleJson) =>
              VehicleModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList();
    }
    print(
        'ListVehicleModel fromJson: Parsed vehicles count: ${vehicles.length}');
    return ListVehicleModel(
      data: vehicles,
      totalPages: json['data']?['totalPages'] as int?,
      pageNumber: json['data']?['pageNumber'] as int?,
      pageSize: json['data']?['pageSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'data': data.map((vehicle) => vehicle.toJson()).toList(),
    };
    if (totalPages != null) result['totalPages'] = totalPages;
    if (pageNumber != null) result['pageNumber'] = pageNumber;
    if (pageSize != null) result['pageSize'] = pageSize;
    return result;
  }
}
