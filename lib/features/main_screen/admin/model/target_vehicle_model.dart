class TargetVehicleModel {
  final int id;
  final num distance;
  final String model;
  final int year;
  final num pricePerDay;
  final String transmission;
  num? rate;
  final String mainImagePath;

  TargetVehicleModel({
    required this.id,
    required this.distance,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.transmission,
    this.rate,
    required this.mainImagePath,
  });

  factory TargetVehicleModel.fromJson(Map<String, dynamic> json) {
    return TargetVehicleModel(
      id: json['id'],
      distance: json['distance'],
      model: json['model'],
      year: json['year'],
      pricePerDay: json['pricePerDay'],
      transmission: json['transmission'],
      rate: json['rate'],
      mainImagePath: json['mainImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distance': distance,
      'model': model,
      'year': year,
      'pricePerDay': pricePerDay,
      'transmission': transmission,
      'rate': rate,
      'mainImagePath': mainImagePath,
    };
  }
}
