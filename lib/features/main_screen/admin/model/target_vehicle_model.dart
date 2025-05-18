class TargetVehicleModel {
  final int id;
  final num distance;
  final String model;
  final int year;
  final num pricePerDay;
  final bool isFavourite;
  final String transmission;
  final double rate;
  final String mainImagePath;

  TargetVehicleModel({
    required this.id,
    required this.distance,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.isFavourite,
    required this.transmission,
    required this.rate,
    required this.mainImagePath,
  });

  factory TargetVehicleModel.fromJson(Map<String, dynamic> json) {
    return TargetVehicleModel(
      id: json['id'],
      distance: json['distance'],
      model: json['model'],
      year: json['year'],
      pricePerDay: json['pricePerDay'],
      isFavourite: json['isFavourite'],
      transmission: json['transmission'],
      rate: (json['rate'] as num).toDouble(),
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
      'isFavourite': isFavourite,
      'transmission': transmission,
      'rate': rate,
      'mainImagePath': mainImagePath,
    };
  }
}
