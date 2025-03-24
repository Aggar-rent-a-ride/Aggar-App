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
      id: json['id'],
      name: json['name'],
      slogenPath: json['slogenPath'],
    );
  }
}
