class Car {
  final String name;
  final double pricePerHour;
  final double? rating;
  final int distance;
  final String assetImage;

  Car({
    required this.name,
    required this.pricePerHour,
    this.rating,
    required this.distance,
    required this.assetImage,
  });
}
