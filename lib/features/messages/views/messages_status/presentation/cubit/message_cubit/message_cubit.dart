import 'dart:io';

import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as dio;
import 'package:path_provider/path_provider.dart';
part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  MessageCubit() : super(MessageInitial());
  Future<void> fetchMimeType(String url) async {
    final mimeType = await getFileMimeType(url);
    emit(MessageLoaded(messageUrl: url, mimeType: mimeType));
  }

  String getFileName(String path) {
    final Uri uri = Uri.parse(path);
    final String fileName = uri.pathSegments.last;
    return fileName;
  }

  Future<String?> downloadFile(String messagePath) async {
    try {
      emit(MessageLoading());

      debugPrint("Downloading file from path: $messagePath");
      final String fileUrl = "${EndPoint.baseUrl}$messagePath";
      debugPrint("Full URL: $fileUrl");

      // First check if the file exists
      final String fileType = await getFileMimeType(messagePath);
      debugPrint("File MIME type: $fileType");

      // Create a standard Dio instance for this specific download
      final dio = Dio();
      final response = await dio.get(
        fileUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      // Now response should be a proper Response object with statusCode
      debugPrint("Response status: ${response.statusCode}");

      if (response.statusCode != 200) {
        emit(MessageFailure(
            "Server returned status code: ${response.statusCode}"));
        return null;
      }

      // Data should be Uint8List
      final bytes = response.data as Uint8List;
      if (bytes.isEmpty) {
        emit(MessageFailure("Downloaded file is empty"));
        return null;
      }

      // Get app's download directory
      final Directory directory = await getApplicationDocumentsDirectory();
      debugPrint("Saving to directory: ${directory.path}");

      // Create a unique filename with proper extension
      final String extension = getFileExtension(fileType, messagePath);
      final String fileName =
          'file_${DateTime.now().millisecondsSinceEpoch}$extension';
      final String filePath = '${directory.path}/$fileName';

      debugPrint("Saving to path: $filePath");

      // Write the file to disk
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      final fileSize = await file.length();
      debugPrint("File saved successfully. Size: $fileSize bytes");

      emit(MessageSuccess());
      return filePath;
    } catch (e, stackTrace) {
      debugPrint("Error downloading file: $e");
      debugPrint("Stack trace: $stackTrace");
      emit(MessageFailure(e.toString()));
      return null;
    }
  }

  String getFileExtension(String fileType, String originalPath) {
    if (originalPath.contains('.')) {
      final String originalExtension =
          originalPath.split('.').last.toLowerCase();
      final validExtensions = [
        '.pdf',
        '.doc',
        '.docx',
        '.xls',
        '.xlsx',
        '.ppt',
        '.pptx',
        '.txt',
      ];

      if (validExtensions.contains('.$originalExtension')) {
        return '.$originalExtension';
      }
    }
    switch (fileType) {
      case 'pdf':
        return '.pdf';
      case 'word':
        return '.docx';
      case 'excel':
        return '.xlsx';
      case 'powerpoint':
        return '.pptx';
      case 'text':
        return '.txt';
      default:
        return '.bin';
    }
  }

  Future<String> getFileMimeType(String url) async {
    final String fullUrl = EndPoint.baseUrl + url;
    final response = await dio.head(
      Uri.parse(fullUrl),
    );
    final contentType = response.headers['content-type'] ?? '';
    if (contentType.startsWith('image/')) {
      return 'image';
      /**  * ".jpg",    "image/jpeg"   
           * ".jpeg",   "image/jpeg"
           * ".gif",    "image/gif"*/
    } else if (contentType == 'application/pdf') {
      return 'pdf';
      // * ".pdf",    "application/pdf"
    } else if (contentType.contains('officedocument.wordprocessingml') ||
        contentType == 'application/msword') {
      return 'word';
      /** * ".docx",   "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          * ".doc",    "application/msword" */
    } else if (contentType.contains('officedocument.spreadsheetml') ||
        contentType == 'application/vnd.ms-excel') {
      return 'excel';
      /** * ".xlsx",   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          * ".xls",    "application/vnd.ms-excel" */
    } else if (contentType.contains('officedocument.presentationml') ||
        contentType == 'application/vnd.ms-powerpoint') {
      return 'powerpoint';
      /** * ".pptx",   "application/vnd.openxmlformats-officedocument.presentationml.presentation"
          * ".ppt",    "application/vnd.ms-powerpoint" */
    } else if (contentType.startsWith('text/')) {
      return 'text';
    } else {
      return 'other';
    }
  }

  Future<void> getMessages(String userId, String dateTime, String pageSize,
      String dateFilter, String accessToken) async {
    try {
      emit(MessageLoading());
      final response = await dioConsumer.get(
        "${EndPoint.getMessageBetween}?userId=$userId&dateTime=$dateTime&pageSize=$pageSize&dateFilter=$dateFilter",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response == null) {
        emit(MessageFailure("No response received from server."));
        return;
      }
      final ListMessageModel messages = ListMessageModel.fromJson(response);
      await Future.delayed(const Duration(seconds: 2));
      emit(MessageSuccess(messages));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }
}
