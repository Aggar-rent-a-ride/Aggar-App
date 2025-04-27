import 'package:aggar/core/api/end_points.dart';

class UserModel {
  final int id;
  final String name;
  final String? imagePath;

  const UserModel({
    required this.id,
    required this.name,
    this.imagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKey.getMyChatUserId] as int,
      name: json[ApiKey.getMyChatUserName] as String,
      imagePath: json[ApiKey.getMyChatUserPfp] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getMyChatUserId: id,
      ApiKey.getMyChatUserName: name,
      ApiKey.getMyChatUserPfp: imagePath,
    };
  }
}
