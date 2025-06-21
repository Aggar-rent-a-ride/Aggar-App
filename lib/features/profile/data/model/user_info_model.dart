class UserInfoModel {
  final int id;
  final String name;
  final String userName;
  final String address;
  final String role;

  UserInfoModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.address,
    required this.role,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      name: json['name'],
      userName: json['userName'],
      address: json['address'],
      role: json['role'],
    );
  }
}
