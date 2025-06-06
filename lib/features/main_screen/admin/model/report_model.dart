import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/main_screen/admin/model/reporter_model.dart';
import 'package:aggar/features/main_screen/admin/model/target_app_user_model.dart';
import 'package:aggar/features/main_screen/admin/model/target_customer_review_model.dart';
import 'package:aggar/features/main_screen/admin/model/target_file_model.dart';
import 'package:aggar/features/main_screen/admin/model/target_message_model.dart';
import 'package:aggar/features/main_screen/admin/model/target_renter_review_model.dart';
import 'package:aggar/features/main_screen/admin/model/target_vehicle_model.dart';

class ReportModel {
  final int id;
  final String description;
  final String createdAt;
  final String status;
  final ReporterModel reporter;
  final String targetType;
  final TargetAppUserModel? targetAppUser;
  final TargetVehicleModel? targetvehicle;
  final TargetRenterReviewModel? targetRenterReview;
  final TargetCustomerReviewModel? targetCustomerReview;
  final TargetMessageModel? targetMessage;
  final TargetFileModel? targetFile;
  const ReportModel(
      {required this.id,
      required this.description,
      required this.createdAt,
      required this.status,
      required this.reporter,
      required this.targetType,
      this.targetAppUser,
      this.targetvehicle,
      this.targetCustomerReview,
      this.targetMessage,
      this.targetRenterReview,
      this.targetFile});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json[ApiKey.getFilterReportId],
      description: json[ApiKey.getFilterReportDescrption],
      createdAt: json[ApiKey.getFilterReportCreatedAt],
      status: json[ApiKey.getFilterReportStatus],
      reporter: ReporterModel.fromJson(json[ApiKey.getFilterReportReporter]),
      targetType: json[ApiKey.getFilterReportTargetType],
      targetAppUser: json[ApiKey.getFilterReportTargetAppUser] != null
          ? TargetAppUserModel.fromJson(
              json[ApiKey.getFilterReportTargetAppUser])
          : null,
      targetvehicle: json[ApiKey.getFilterReportTargetVehicle] != null
          ? TargetVehicleModel.fromJson(
              json[ApiKey.getFilterReportTargetVehicle])
          : null,
      targetCustomerReview:
          json[ApiKey.getFilterReportTargetCustomerReview] != null
              ? TargetCustomerReviewModel.fromJson(
                  json[ApiKey.getFilterReportTargetCustomerReview])
              : null,
      targetRenterReview: json[ApiKey.getFilterReportTargetRenterReview] != null
          ? TargetRenterReviewModel.fromJson(
              json[ApiKey.getFilterReportTargetRenterReview])
          : null,
      targetMessage: json["targetContentMessage"] != null
          ? TargetMessageModel.fromJson(json["targetContentMessage"])
          : null,
      targetFile: json["targetFileMessage"] != null
          ? TargetFileModel.fromJson(json["targetFileMessage"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.getFilterReportId: id,
      ApiKey.getFilterReportDescrption: description,
      ApiKey.getFilterReportCreatedAt: createdAt,
      ApiKey.getFilterReportStatus: status,
      ApiKey.getFilterReportReporter: reporter.toJson(),
      ApiKey.getFilterReportTargetType: targetType,
      ApiKey.getFilterReportTargetAppUser: targetAppUser?.toJson(),
      ApiKey.getFilterReportTargetVehicle: targetvehicle?.toJson(),
      ApiKey.getFilterReportTargetCustomerReview:
          targetCustomerReview?.toJson(),
      ApiKey.getFilterReportTargetRenterReview: targetRenterReview?.toJson(),
      ApiKey.getFilterReportTargetMessageContent: targetMessage?.toJson(),
      "targetFileMessage": targetFile?.toJson()
    };
  }
}
