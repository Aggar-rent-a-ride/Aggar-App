import 'package:aggar/core/api/end_points.dart';
import 'package:http/http.dart' as dio;

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
