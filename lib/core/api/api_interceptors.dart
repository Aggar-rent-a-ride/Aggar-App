import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.headers[ApiKey.token] =
    //     CacheHelper().getData(key: ApiKey.token) != null
    //         ? 'Agger ${CacheHelper().getData(key: ApiKey.token)}'
    //         : null;
    // super.onRequest(options, handler);
  }
}
