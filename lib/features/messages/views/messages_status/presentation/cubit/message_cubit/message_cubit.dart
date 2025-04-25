import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as dio;
part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  MessageCubit() : super(MessageInitial());
  Future<void> fetchMimeType(String url) async {
    final mimeType = await getFileMimeType(url);
    emit(MessageLoaded(messageUrl: url, mimeType: mimeType));
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
      print(response);
      if (response == null) {
        emit(MessageFailure("No response received from server."));
        return;
      }
      final ListMessageModel messages = ListMessageModel.fromJson(response);

      print("Number of messages: ${messages.data.length}");
      await Future.delayed(const Duration(seconds: 2));
      emit(MessageSuccess(messages));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }
}
