import 'package:aggar/core/api/end_points.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String? imagePath;
  final num? rate;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.imagePath,
    this.rate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKey.getSearchUsersId],
      name: json[ApiKey.getSearchUsersName],
      username: json[ApiKey.getSearchUsersUsername],
      imagePath: json[ApiKey.getSearchUsersImage],
      rate: json[ApiKey.getSearchUsersrate],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getFilterReportReporterId: id,
      ApiKey.getFilterReportReporterName: name,
      ApiKey.getSearchUsersUsername: username,
      ApiKey.getFilterReportReporterPfp: imagePath,
      ApiKey.getSearchUsersrate: rate,
    };
  }
}
