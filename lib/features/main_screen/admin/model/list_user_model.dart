import 'package:aggar/features/main_screen/admin/model/user_model.dart';

class ListUserModel {
  final List<UserModel> data;
  final int? totalPages;
  final int? pageNumber;
  final int? pageSize;

  ListUserModel({
    required this.data,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
  });

  factory ListUserModel.fromJson(Map<String, dynamic> json) {
    List<UserModel> users = [];
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      var nestedData = json['data'] as Map<String, dynamic>;
      if (nestedData.containsKey('data') && nestedData['data'] is List) {
        users = (nestedData['data'] as List)
            .map((vehicleJson) =>
                UserModel.fromJson(vehicleJson as Map<String, dynamic>))
            .toList();
      }
    } else if (json.containsKey('data') && json['data'] is List) {
      users = (json['data'] as List)
          .map((vehicleJson) =>
              UserModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList();
    }
    return ListUserModel(
      data: users,
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
