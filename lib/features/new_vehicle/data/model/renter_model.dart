class RenterModel {
  final int id;
  final String? imagePath;
  final String name;
  final double? rate;

  RenterModel({
    required this.id,
    this.imagePath,
    required this.name,
    this.rate,
  });

  factory RenterModel.fromJson(Map<String, dynamic> json) {
    return RenterModel(
      id: json['id'] ?? 0,
      imagePath: json['imagePath'],
      name: json['name'] ?? '',
      rate: json['rate'] != null
          ? double.tryParse(json['rate'].toString())
          : null,
    );
  }
}
