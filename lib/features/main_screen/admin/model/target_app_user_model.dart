import 'package:aggar/core/api/end_points.dart';

class TargetAppUserModel {
  final int id;
  final String name;
  final String? imagePath;

  TargetAppUserModel({
    required this.id,
    required this.name,
    this.imagePath,
  });

  factory TargetAppUserModel.fromJson(Map<String, dynamic> json) {
    return TargetAppUserModel(
      id: json[ApiKey.getFilterReportTargetAppUserId],
      name: json[ApiKey.getFilterReportTargetAppUserName],
      imagePath: json[ApiKey.getFilterReportTargetAppUserPfp],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getFilterReportTargetAppUserId: id,
      ApiKey.getFilterReportTargetAppUserName: name,
      ApiKey.getFilterReportTargetAppUserPfp: imagePath,
    };
  }
}
