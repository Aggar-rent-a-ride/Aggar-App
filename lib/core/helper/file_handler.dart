import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class FileHandler {
  static Future<PermissionStatus> requestPhotoPermission() async {
    print('Requesting photo permission');
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Permission permissionToRequest;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permissionToRequest = Permission.storage;
      } else {
        permissionToRequest = Permission.photos;
      }
    } else {
      permissionToRequest = Permission.photos;
    }

    if (await permissionToRequest.status.isDenied) {
      final status = await permissionToRequest.request();
      print('Permission status: $status');
      return status;
    }
    print('Permission already granted');
    return PermissionStatus.granted;
  }

  static Future<File?> downloadFile(String url, String fileName) async {
    print('Downloading file from URL: $url');
    try {
      Dio dio = Dio();
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';
      print('Saving file to: $filePath');
      await dio.download(url, filePath);
      final file = File(filePath);
      if (await file.exists()) {
        print('File downloaded successfully: $filePath');
        return file;
      } else {
        print('File does not exist after download: $filePath');
        return null;
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  static Future<void> openFile(File file) async {
    print('Opening file: ${file.path}');
    try {
      final result = await OpenFile.open(file.path);
      print('Open file result: ${result.message}');
    } catch (e) {
      print('Error opening file: $e');
    }
  }
}
