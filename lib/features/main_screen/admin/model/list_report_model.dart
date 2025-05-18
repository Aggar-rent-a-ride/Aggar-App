import 'package:aggar/features/main_screen/admin/model/report_model.dart';

class ListReportModel {
  final List<ReportModel> data;
  final int? totalPages;
  final int? pageNumber;
  final int? pageSize;

  ListReportModel({
    required this.data,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
  });

  factory ListReportModel.fromJson(Map<String, dynamic> json) {
    List<ReportModel> vehicles = [];
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      var nestedData = json['data'] as Map<String, dynamic>;
      if (nestedData.containsKey('data') && nestedData['data'] is List) {
        vehicles = (nestedData['data'] as List)
            .map((vehicleJson) =>
                ReportModel.fromJson(vehicleJson as Map<String, dynamic>))
            .toList();
      }
    } else if (json.containsKey('data') && json['data'] is List) {
      vehicles = (json['data'] as List)
          .map((vehicleJson) =>
              ReportModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList();
    }
    return ListReportModel(
      data: vehicles,
      totalPages: json['data']?['totalPages'] as int?,
      pageNumber: json['data']?['pageNumber'] as int?,
      pageSize: json['data']?['pageSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'data': data.map((vehicle) => vehicle.toJson()).toList(),
    };
    if (totalPages != null) result['totalPages'] = totalPages;
    if (pageNumber != null) result['pageNumber'] = pageNumber;
    if (pageSize != null) result['pageSize'] = pageSize;
    return result;
  }
}
