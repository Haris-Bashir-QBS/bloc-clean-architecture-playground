import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  final Logger logger = Logger();


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(''' 
    🚀 REQUEST: ${options.method} ${options.uri}
    Headers: ${options.headers}
    Data: ${options.data}
    QueryParams: ${options.queryParameters}
    ''');
    handler.next(options); // Continue with the request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('''
    ✅ RESPONSE: ${response.requestOptions.uri}
    Status Code: ${response.statusCode}
    Data: ${response.data}
    ''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //log(err.toString());
    logger.e('''
    ❌ ERROR: ${err.requestOptions.uri}
    Status Code: ${err.response?.statusCode}
    data : ${err.response?.data}
    ''');
    handler.next(err); // Continue handling the error
  }
}
