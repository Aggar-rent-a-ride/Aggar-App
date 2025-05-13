import 'package:dio/dio.dart';

String handleSearchError(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Network timeout. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode ?? 'Unknown'}';
      default:
        return 'An unexpected network error occurred.';
    }
  }
  return 'An unexpected error occurred: $error';
}
