import 'dart:io';
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
  final String mainImagePath; // Changed from File to String
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
  final List<String> vehicleImages; // Changed from List<File?> to List<String>
  final List<dynamic> discounts;

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
    required this.discounts,
  });

  factory VehicleDataModel.fromJson(Map<String, dynamic> json) {
    return VehicleDataModel(
      id: json['id'] ?? 0,
      renter:
          json['renter'] != null ? RenterModel.fromJson(json['renter']) : null,
      numOfPassengers: json['numOfPassengers'] ?? 0,
      rate: json['rate'] != null
          ? double.tryParse(json['rate'].toString())
          : null,
      year: json['year'] ?? 0,
      model: json['model'] ?? '',
      color: json['color'] ?? '',
      mainImagePath: json['mainImagePath'] is String
          ? json['mainImagePath'] ?? ''
          : '', // Handle potential non-string values
      status: json['status'] ?? '',
      physicalStatus: json['physicalStatus'] ?? '',
      transmission: json['transmission'] ?? '',
      pricePerDay: json['pricePerDay'] != null
          ? double.tryParse(json['pricePerDay'].toString()) ?? 0.0
          : 0.0,
      requirements: json['requirements'],
      extraDetails: json['extraDetails'],
      address: json['address'] ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : LocationModel(latitude: 0, longitude: 0),
      vehicleType: VehicleType.fromJson(json['vehicleType']),
      vehicleBrand: VehicleBrand.fromJson(json['vehicleBrand']),
      vehicleImages: json['vehicleImages'] != null
          ? List<String>.from(json['vehicleImages']
              .map((image) => image is String ? image : image.toString()))
          : [],
      discounts: json['discounts'] ?? [],
    );
  }
}
