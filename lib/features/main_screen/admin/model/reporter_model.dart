import 'package:aggar/core/api/end_points.dart';

class ReporterModel {
  final int id;
  final String name;
  final String? imagePath;

  ReporterModel({
    required this.id,
    required this.name,
    this.imagePath,
  });

  factory ReporterModel.fromJson(Map<String, dynamic> json) {
    return ReporterModel(
      id: json[ApiKey.getFilterReportReporterId],
      name: json[ApiKey.getFilterReportReporterName],
      imagePath: json[ApiKey.getFilterReportReporterPfp],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getFilterReportReporterId: id,
      ApiKey.getFilterReportReporterName: name,
      ApiKey.getFilterReportReporterPfp: imagePath,
    };
  }
}
