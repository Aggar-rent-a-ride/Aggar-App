import 'package:aggar/features/new_vehicle/data/model/location_model.dart';

class UserInfoModel {
  final int id;
  final String name;
  final String userName;
  final String address;
  final String role;
  final String? imageUrl;
  final LocationModel location;
  final String? rate;
  final int age;
  final String? bio;

  UserInfoModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.address,
    required this.role,
    this.imageUrl,
    required this.location,
    this.rate,
    required this.age,
    this.bio,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
        bio: json['bio'],
        id: json['id'],
        name: json['name'],
        userName: json['userName'],
        address: json['address'],
        role: json['role'],
        location: LocationModel(
          latitude: json['location']['latitude'],
          longitude: json['location']['longitude'],
        ),
        age: json['age'],
        imageUrl:
            json['imagePath'] != null ? json['imagePath'] as String : null,
        rate: json['rate']?.toString());
  }
}
