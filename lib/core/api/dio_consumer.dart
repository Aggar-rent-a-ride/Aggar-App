import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/core/api/api_interceptors.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/errors/error_model.dart';
import 'package:aggar/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      // Debug info
      print("POST DATA TYPE: ${data.runtimeType}");
      print("IS FROM DATA: $isFromData");

      dynamic finalData;
      if (data is FormData) {
        finalData = data;
        print("USING FORMDATA DIRECTLY");
      } else if (isFromData) {
        try {
          finalData = FormData.fromMap(data);
          print("CONVERTED TO FORMDATA");
        } catch (e) {
          print("FAILED TO CONVERT TO FORMDATA: $e");
          finalData = data;
        }
      } else {
        finalData = data;
      }

      final response = await dio.post(
        path,
        data: finalData,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    } catch (e) {
      print("ERROR IN POST: $e");
      rethrow;
    }
  }
}
