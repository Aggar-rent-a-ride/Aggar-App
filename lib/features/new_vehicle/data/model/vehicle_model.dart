import 'package:aggar/features/new_vehicle/data/model/location_model.dart';
import 'package:aggar/features/new_vehicle/data/model/renter_model.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_brand_model.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_type_model.dart';

class VehicleDataModel {
  final int id;
  final RenterModel? renter;
  final int numOfPassengers;
  final double? rate;
  final int year;
  final String model;
  final String color;
  final String mainImagePath;
  final String status;
  final String physicalStatus;
  final String transmission;
  final double pricePerDay;
  final String? requirements;
  final String? extraDetails;
  final String address;
  final LocationModel location;
  final VehicleType vehicleType;
  final VehicleBrand vehicleBrand;
  final List<String> vehicleImages;
  final List<dynamic>? discounts;

  VehicleDataModel({
    required this.id,
    this.renter,
    required this.numOfPassengers,
    this.rate,
    required this.year,
    required this.model,
    required this.color,
    required this.mainImagePath,
    required this.status,
    required this.physicalStatus,
    required this.transmission,
    required this.pricePerDay,
    this.requirements,
    this.extraDetails,
    required this.address,
    required this.location,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleImages,
    this.discounts,
  });

  factory VehicleDataModel.fromJson(Map<String, dynamic> json) {
    // Safely handle nested data structure
    final data = json['data'] ?? json;

    return VehicleDataModel(
      id: data['id'] ?? 0,
      renter:
          data['renter'] != null ? RenterModel.fromJson(data['renter']) : null,
      numOfPassengers: data['numOfPassengers'] ?? 0,
      rate: data['rate'] != null
          ? double.tryParse(data['rate'].toString())
          : null,
      year: data['year'] ?? 0,
      model: data['model'] ?? '',
      color: data['color'] ?? '',
      mainImagePath:
          data['mainImagePath'] is String ? data['mainImagePath'] ?? '' : '',
      status: data['status'] ?? '',
      physicalStatus: data['physicalStatus'] ?? '',
      transmission: data['transmission'] ?? '',
      pricePerDay: data['pricePerDay'] != null
          ? double.tryParse(data['pricePerDay'].toString()) ?? 0.0
          : 0.0,
      requirements: data['requirements'],
      extraDetails: data['extraDetails'],
      address: data['address'] ?? '',
      location: data['location'] != null
          ? LocationModel.fromJson(data['location'])
          : LocationModel(latitude: 0, longitude: 0),
      vehicleType: VehicleType.fromJson(data['vehicleType']),
      vehicleBrand: VehicleBrand.fromJson(data['vehicleBrand']),
      vehicleImages: data['vehicleImages'] != null
          ? List<String>.from(data['vehicleImages']
              .map((image) => image is String ? image : image.toString()))
          : [],
      discounts: data['discounts'] ?? [],
    );
  }
}
