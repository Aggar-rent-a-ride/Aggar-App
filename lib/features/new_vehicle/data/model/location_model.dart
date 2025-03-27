// Vehicle Data Model

class LocationModel {
  final double longitude;
  final double latitude;

  LocationModel({
    required this.longitude,
    required this.latitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}
